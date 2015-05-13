module Dtw
  class Naive
    attr_reader :series, :options
    def initialize(*series)
      @options = (series.pop if series.last.is_a? Hash) || {}
      @series = series
    end

    def slope_pattern
      @slope_pattern ||= options.fetch(:slope_pattern, [[1, 1, 1], [0, 1, 1], [1, 0, 1]])
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

      pattern = slope_pattern.map do |(di, dj, weight)|
        next if ((i - di) < 0) || ((j - dj) < 0)

        [i - di, j - dj, weight * warping_matrix(g, i - di, j - dj, z + 1)]
      end.compact.min_by { |(_, _, cost)| cost }

      g[:path][[i, j]] = pattern[0..1]

      g[[i, j]] = pattern.last + d
    end

    def distance(i, j)
      a, b = series.first[i], series.last[j]
      z = (a - b)**2
      z
    end
  end
end
