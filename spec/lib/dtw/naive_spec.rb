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

  describe "#pattern" do
    it "defaults to 1 from either side" do
      expect(subject.pattern).to match_array [[1, 1], [0, 1], [1, 0]]
    end

    it "can be provided as an option" do
      subject = described_class.new pattern: [2, 2]
      expect(subject.pattern).to eq [2, 2]
    end
  end

  describe "#window" do
    subject { naive([], []) }

    it "defaults to the full set" do
      expect(subject.window.r).to eq Float::INFINITY
    end

    it "can be provided as an option" do
      subject = described_class.new [], [], window: Dtw::Window.new(5)
      expect(subject.window.r).to eq 5
    end
  end

  describe "#warp_factor" do
    let(:series_a) { [1, 2, 2, 1, 0, 1, 1, 2, 1, 2] }
    let(:series_b) { [3, 4, 5, 3, 3, 2, 3, 4, 2, 3] }
    it "reports no warping when the series are equal" do
      expect(naive([1, 1, 1], [2, 2, 2]).warp_factor).to eq 0
    end

    it "reports some warping" do
      w = naive(series_a, series_b).warp_factor
      expect(w).to (be > 0).and(be < 1)
    end
  end

  describe "#path" do
    let(:series_a) { [1, 2, 2, 1, 0, 1, 1, 2, 1, 2] }
    let(:series_b) { [3, 4, 5, 3, 3, 2, 3, 4, 2, 3] }

    it "is correct" do
      expect(naive(series_a, series_b).path).to match_array [[0, 0], [1, 1], [1, 2], [1, 3], [2, 4], [3, 5], [4, 5], [5, 5], [6, 5], [7, 6], [7, 7], [8, 8], [9, 9]]
    end

    it "supports various patterns" do
      pending "need better data"
      expect(naive(series_a, series_b, pattern: [[1, 1], [2, 1], [1, 2]]).path).to match_array [[0, 0], [1, 1], [1, 2], [1, 3], [2, 4], [3, 5], [4, 5], [5, 5], [6, 5], [7, 6], [7, 7], [8, 8], [9, 9]]
    end
  end

  def naive(*args)
    described_class.new(*args)
  end
end
