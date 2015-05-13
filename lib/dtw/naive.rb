module Dtw
  class Naive
    attr_reader :series, :options
    def initialize(*series)
      @options = (series.pop if series.last.is_a? Hash) || {}
      @series = series
    end

    def pattern
      @pattern ||= options.fetch(:pattern, [[1, 1], [0, 1], [1, 0]])
    end

    def window
      @window ||= options.fetch(:window, Window.new).size(series.first.length, series.last.length)
    end

    def path
      @path ||= begin
        path = []

        i = series.first.length - 1
        j = series.last.length - 1

        while i > 0 || j > 0
          path.unshift [i, j]
          i, j = matrix[:path][[i, j]]
        end

        path.unshift [0, 0]

        path
      end
    end

    def warp_factor
      (path.length - series.first.length) / series.first.length.to_f
    end

    private

    def matrix
      @matrix ||= begin
        g = { path: {} }
        warping_matrix(g, series.first.length - 1, series.last.length - 1)
        g
      end
    end

    def warping_matrix(g, i, j, z = 0)
      return g[[i, j]] if g[[i, j]]
      d = distance(i, j)

      if window && !window.include?(i, j)
        return Float::INFINITY
      end

      if i == 0 && j == 0
        g[:path][[i, j]] = [nil, nil]
        g[[i, j]] = d
        return d
      end

      match = pattern.map do |(di, dj, weight)|
        weight ||= 1
        next if ((i - di) < 0) || ((j - dj) < 0)

        dii = di
        djj = dj

        cost = warping_matrix(g, i - di, j - dj, z + 1)

        while dii > 1
          dii -= 1
          next if (i - dii) < 0
          cost += warping_matrix(g, i - dii, j - dj, z + 1)
        end

        while djj > 1
          djj -= 1
          next if (j - djj) < 0
          cost += warping_matrix(g, i - di, j - djj, z + 1)
        end

        [i - di, j - dj, weight * cost]
      end.compact.min_by { |(_, _, cost)| cost }

      match ||= [0, 0, warping_matrix(g, 0, 0), z + 1]

      g[:path][[i, j]] = match[0..1]

      g[[i, j]] = match.last + d
    end

    def distance(i, j)
      a, b = series.first[i], series.last[j]
      z = (a - b)**2
      z
    end
  end
end
