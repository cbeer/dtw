module Dtw
  class Window
    attr_reader :r, :n, :m
    def initialize(r = Float::INFINITY)
      @r = r
    end

    def size(n, m)
      @n = n
      @m = m
      self
    end

    def include?(i, j)
      ((i + 1) - (n / (m / (j + 1)))).abs < r
    end
  end
end
