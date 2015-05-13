$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dtw'

def dump_matrix(h)
  arr = []
  h.each do |(i, j), v|
    next if i == :path
    arr[j] ||= []
    arr[j][i] = v
  end

  arr

  arr.each_with_index do |row, j|
    row.each_with_index do |v, i|
      if i == 0 && j == 0
        print " "*6
        next
      end
      i1, j1 = h[:path][[i, j]]

      if i1 < i && j1 < j
        print "╲     "
      elsif i1 < i
        print "_" * 6
      elsif j1 < j
        print "  |   "
      end
    end if h[:path]

    print "\n"

    row.each_with_index do |v, i|
      if v == [nil, nil]
        print " [    ] "
      else
        print v.to_s.center(6)
      end
    end

    print "\n"
  end

  dump(h[:path]) if h[:path]
end