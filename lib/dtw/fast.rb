require 'set'

module Dtw
  ##
  # Implementation of FastDTW described by
  # https://gi.cebitec.uni-bielefeld.de/teaching/2007summer/jclub/papers/Salvador2004.pdf
  class Fast < Naive
    def radius
      @radius ||= options.fetch(:radius, 1)
    end

    def matrix
      @matrix ||= begin
        min_size = radius + 2

        if series[0].length <= min_size || series[1].length <= min_size
          super
        else
          p = Dtw::Fast.new(reduce(series[0]), reduce(series[1]), radius: radius)
          w = Dtw::Fast::Window.new(radius, p.path)
          Dtw::Naive.new(series[0], series[1], window: w).send(:matrix)
        end
      end
    end

    def reduce(series)
      series.each_slice(2).map do |s|
        s.reduce(:+) / s.length.to_f
      end
    end

    class Window < Dtw::Window
      def initialize(r, p)
        super(r)
        @p = p
      end

      def path
        @path ||= begin
          s = Set.new @p

          @p.each do |(i, j)|
            (-r..r).each do |n|
              s += [[i + n, j], [i, j + n], [i + n, j + n]]
            end
          end

          w = Set.new

          s.each do |(i, j)|
            w += [[i * 2, j * 2], [i * 2, j * 2 + 1], [i * 2 + 1, j * 2], [i * 2 + 1, j * 2 + 1]]
          end

          w
        end
      end

      def include?(i, j)
        path.include? [i, j]
      end
    end
  end
end
