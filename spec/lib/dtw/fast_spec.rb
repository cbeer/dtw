require 'spec_helper'

describe Dtw::Fast do
  describe "#matrix" do
    let(:series_a) { [1, 2, 2, 1, 0, 1, 1, 2, 1, 2, 5, 4, 3, 2, 2, 3] }
    let(:series_b) { [3, 4, 5, 3, 3, 2, 3, 4, 2, 3, 3, 4, 4, 3, 2, 1] }
    subject { described_class.new(series_a, series_b) }
    it "is correct" do
      expect(subject.path).to match_array [[0, 0], [1, 1], [1, 2], [1, 3], [2, 4], [3, 5], [4, 5], [5, 5], [6, 5], [7, 5], [8, 5], [9, 6], [10, 7], [11, 7], [12, 8], [12, 9], [12, 10], [12, 11], [12, 12], [12, 13], [13, 14], [14, 14], [15, 15]]
    end
  end

  xit "benchmarks" do
    # Profile the code
    result = Benchmark.measure do
      described_class.new(Array.new(1000, 1), Array.new(1000, 2)).path
    end

    puts result
  end
end
