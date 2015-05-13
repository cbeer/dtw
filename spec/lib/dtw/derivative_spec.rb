require 'spec_helper'

describe Dtw::Derivative do
  describe "#matrix" do
    let(:series_a) { [1, 2, 2, 1, 0, 1, 1, 2, 1, 2] }
    let(:series_b) { [3, 4, 5, 3, 3, 2, 3, 4, 2, 3] }
    subject { described_class.new(series_a, series_b) }
    it "is correct" do
      expect(subject.path).to match_array [[0, 0], [1, 1], [2, 2], [3, 3], [3, 4], [4, 5], [5, 6], [6, 6], [7, 7], [8, 8], [9, 9]]
    end
  end
end
