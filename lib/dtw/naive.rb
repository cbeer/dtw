require 'matrix'

class Dtw::Matrix < Matrix
  public :"[]="
end

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
      @window ||= options.fetch(:window, Window.new).size(series[0].length, series[1].length)
    end

    def path
      @path ||= begin
        path = []

        i = series[0].length - 1
        j = series[1].length - 1

        while i > 0 || j > 0
          path.unshift [i, j]
          i, j = matrix.path[i, j]
        end

        path.unshift [0, 0]

        path
      end
    end

    def warp_factor
      (path.length - series[0].length) / series[0].length.to_f
    end

    private

    def matrix
      @matrix ||= begin
        g = Struct.new(:path, :matrix).new(Dtw::Matrix.build(series[0].length, series[1].length) { nil }, Dtw::Matrix.build(series[0].length, series[1].length) { nil })
        warping_matrix(g, series[0].length - 1, series[1].length - 1)
        g
      end
    end

    def warping_matrix(g, i, j, z = 0)
      if g.matrix[i, j] # previously calculated
        g.matrix[i, j]
      elsif i < 0 || j < 0 || (window && !window.include?(i, j)) # outside window
        Float::INFINITY
      elsif i == 0 && j == 0 # base case
        d = distance(i, j)
        g.path[i, j] = [nil, nil]
        g.matrix[i, j] = d
      else # recursion
        # cost of the new cell is the minimum cost cell reachable using the pattern
        # plus the distance of this cell
        match = pattern.map do |(di, dj, weight)|
          weight ||= 1

          dii = di
          djj = dj

          cost = warping_matrix(g, i - di, j - dj, z + 1)

          while dii > 1 && cost < Float::INFINITY
            dii -= 1
            cost += warping_matrix(g, i - dii, j - dj, z + 1)
          end

          while djj > 1 && cost < Float::INFINITY
            djj -= 1
            cost += warping_matrix(g, i - di, j - djj, z + 1)
          end

          [i - di, j - dj, weight * cost]
        end.min_by { |(_, _, cost)| cost }

        g.path[i, j] = match[0..1]

        g.matrix[i, j] = match[2] + distance(i, j)
      end
    end

    def distance(i, j)
      a, b = series[0][i], series[1][j]
      z = (a - b)**2
      z
    end
  end
end
