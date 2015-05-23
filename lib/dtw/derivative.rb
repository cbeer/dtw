module Dtw
  ##
  # Implementation of Derivative Dynamic Time Warping
  # from https://www.cs.rutgers.edu/~pazzani/Publications/sdm01.pdf
  class Derivative < Naive
    def distance(i, j)
      a = derivative(series.first, i)
      b = derivative(series.last, j)

      d = a.zip(b).inject(0) do |memo, (v1, v2)|
        memo + (v1 - v2)**2
      end

      d / a.length.to_f
    end

    private

    def derivative(series, i)
      Array(series[i]).each_with_index.map do |c, c_idx|
        n = (Array(series[i + 1])[c_idx] if series.length < i) || c
        p = (Array(series[i - 1])[c_idx] if i > 0) || c
        ((c - p) + ((n - p) / 2.0)) / 2.0
      end
    end
  end
end
