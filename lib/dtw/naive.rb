module Dtw
  class Naive
    attr_reader :series, :options
    def initialize(*series)
      @options = (series.pop if series.last.is_a? Hash) || {}
      @series = series
    end

    def slope_weight
      @slope_weight ||= options.fetch(:slope_weight, 1)
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

    private

    def matrix
      @matrix ||= begin
        g = { path: {} }
        warping_matrix(g, series.first.length - 1, series.last.length - 1)
        g
      end
    end

    def warping_matrix(g, i, j)
      return g[[i, j]] if g[[i, j]]
      d = distance(i, j)

      if i == 0 && j == 0
        g[:path][[i, j]] = [nil, nil]
        g[[i, j]] = d
        return d
      end

      deletion = slope_weight * warping_matrix(g, i, j - 1) if j > 0
      match = warping_matrix(g, i - 1, j - 1) if i > 0 && j > 0
      insertion = slope_weight * warping_matrix(g, i - 1, j) if i > 0

      m = [deletion, match, insertion].compact.min

      g[:path][[i, j]] = if m == match
                           [i - 1, j - 1]
                         elsif m == deletion
                           [i, j - 1]
                         elsif m == insertion
                           [i - 1, j]
                         end

      g[[i, j]] = m + d
    end

    def distance(i, j)
      a, b = series.first[i], series.last[j]
      z = (a - b)**2
      z
    end
  end
end
