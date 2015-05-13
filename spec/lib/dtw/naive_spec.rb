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
end
