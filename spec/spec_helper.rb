# encoding: UTF-8

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dtw'
require 'benchmark'

def dump_matrix(h, highlight = [])
  h.matrix.to_a.each_with_index do |row, i|
    row.each_with_index do |v, j|
      if i == 0 && j == 0
        print " " * 6
        next
      end

      i1, j1 = h.path[i, j]

      if i1.nil? || j1.nil?
        print " " * 6
      elsif i1 < i && j1 < j
        print "  ╲   "
      elsif i1 < i
      print "  |   "
      elsif j1 < j
        print "_" * 6
      end
    end if h.path

    print "\n"

    row.each_with_index do |v, j|
      if v == [nil, nil]
        print " [    ] "
      else
        z = v.round(2) if v
        z ||= "B"
        z = z.to_s.center(6)
        if highlight.include? [i, j]
          print "\033[31m#{z}\033[0m"
        else
          print z
        end
      end
    end

    print "\n"
  end
end
