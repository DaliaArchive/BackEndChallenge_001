require 'rails_helper'

describe Feature, type: :model do
  describe ".diffs" do
    context "features B has same key of features A" do
      let(:feature_a) { Feature.make(key: :a, value: 'a') }

      context "and their values are different" do
        let(:feature_b) { Feature.make(key: :a, value: 'b') }

        subject { Feature.diffs([feature_a], [feature_b]) }

        it "returns values of A and B for the key" do
          is_expected.to eq('a' => [feature_a, feature_b])
        end
      end

      context "and their values are same" do
        let(:feature_b) { Feature.make(key: :a, value: 'a') }

        subject { Feature.diffs([feature_a], [feature_b]) }

        it { is_expected.to be_empty }
      end
    end

    context "features B doen't have same key of features A" do
      let(:feature_a) { Feature.make(key: :a, value: 'a') }
      let(:feature_b) { Feature.make(key: :b, value: 'b') }

      subject { Feature.diffs([feature_a], [feature_b]) }

      it "returns values of B for the key" do
        is_expected.to eq('b' => [Feature::NIL_FEATURE, feature_b])
      end
    end
  end
end
