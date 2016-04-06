require 'rails_helper'

RSpec::Matchers.define :have_same_feature do |expected|
  match do |actual_features|
    actual_features.detect do |actual_feature|
      actual_feature.key == expected.key &&
        actual_feature.value == expected.value
    end
  end
end

describe MaintenanceRecord, type: :model do
  describe "#save_features" do

    context "when robot doesn't have previous maintenance_record" do
      let(:robot) do
        Robot.make!
      end
      let(:maintenance_record) do
        MaintenanceRecord.make!(robot: robot)
      end
      let(:feature) do
        Feature.make
      end

      before do
        maintenance_record.features = [feature]
        maintenance_record.save_features
      end

      it "saves features" do
        expect(maintenance_record.features).to match_array([feature])
      end
    end

    context "when robot has previous maintenance_record" do
      let(:robot) do
        Robot.make!
      end
      let!(:previous_maintenance_record) do
        robot.maintenance_records.make!(features: [previous_feature])
      end
      let(:new_maintenance_record) do
        robot.maintenance_records.make(features: [new_feature])
      end
      let(:previous_feature) do
        Feature.make!(key: :a, value: 'A')
      end

      before do
        new_maintenance_record.save_features
      end

      context "and new features have same key of the previous" do
        let(:new_feature) do
          Feature.make(key: :a, value: 'B')
        end

        it "saves the new feature" do
          expect(new_maintenance_record.features.count).to be(1)
          expect(new_maintenance_record.features).to have_same_feature(new_feature)
        end
      end

      context "and new features don't have same key of the previous" do
        let(:new_feature) do
          Feature.make(key: :b, value: 'B')
        end

        it "saves the previous feature" do
          expect(new_maintenance_record.features).to have_same_feature(previous_feature)
        end

        it "saves the new feature" do
          expect(new_maintenance_record.features).to have_same_feature(new_feature)
        end
      end
    end
  end

  describe "#feature_diffs" do
    let(:robot) { Robot.make! }
    let!(:previous) { robot.maintenance_records.make!(updated_at: 1.day.ago) }
    let!(:new) { robot.maintenance_records.make! }

    before do
      Feature.stub(:diffs)
      new.feature_diffs
    end

    it { expect(Feature).to have_received(:diffs).with(previous.features, new.features) }
  end

  describe "#specify_action" do
    let!(:robot) { Robot.make! }

    context "when robot has previous maintenance_records" do
      let!(:previous) { robot.maintenance_records.make!(updated_at: 1.day.ago) }
      let(:new) { robot.maintenance_records.make! }

      specify { expect(new.action).to eq('update') }
    end
    context "when robot doesn't have previous maintenance_records" do
      let(:new) { robot.maintenance_records.make! }

      specify { expect(new.action).to eq('create') }
    end
  end
end
