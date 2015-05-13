require 'spec_helper'

describe Dtw::Naive do
  describe "#series" do
    it "has series" do
      subject = naive([1, 1], [2, 1])
      expect(subject.series.length).to eq 2
      expect(subject.series.first).to eq [1, 1]
      expect(subject.series.last).to eq [2, 1]
    end
  end

  describe "#options" do
    it "extract options" do
      subject = naive([1, 1], [2, 1], a: 'a')
      expect(subject.options[:a]).to eq 'a'
      expect(subject.series.length).to eq 2
    end
  end

  describe "#slope_weight" do
    it "defaults to 1 " do
      expect(subject.slope_weight).to eq 1
    end

    it "can be provided as an option" do
      subject = described_class.new slope_weight: 2
      expect(subject.slope_weight).to eq 2
    end
  end

  describe "#slope_pattern" do
    it "defaults to 1, 1" do
      expect(subject.slope_pattern).to eq [1, 1]
    end

    it "can be provided as an option" do
      subject = described_class.new slope_pattern: [2, 2]
      expect(subject.slope_pattern).to eq [2, 2]
    end
  end

  describe "#matrix" do
    let(:series_a) { [1, 2, 2, 1, 0, 1, 1, 2, 1, 2] }
    let(:series_b) { [3, 4, 5, 3, 3, 2, 3, 4, 2, 3] }
    subject { naive(series_a, series_b) }
    it "is correct" do
      expect(subject.path).to match_array [[0, 0], [1, 1], [1, 2], [1, 3], [2, 4], [3, 5], [4, 5], [5, 5], [6, 5], [7, 6], [7, 7], [8, 8], [9, 9]]
    end
  end

  def naive(*args)
    described_class.new(*args)
  end

  def dump(h)
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
end
