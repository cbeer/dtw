module Dtw
  ##
  # Implementation of Derivative Dynamic Time Warping
  # from https://www.cs.rutgers.edu/~pazzani/Publications/sdm01.pdf
  class Derivative < Naive
    def distance(i, j)
      a = derivative(series.first, i)
      b = derivative(series.last, j)
      (a - b)**2
    end

    private

    def derivative(series, i)
      c = series[i]
      n = (series[i + 1] if series.length < i) || c
      p = (series[i - 1] if i > 0) || c
      ((c - p) + ((n - p) / 2)) / 2
    end
  end
end
