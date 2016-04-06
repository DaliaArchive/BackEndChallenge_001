require 'rails_helper'

describe Robot, type: :model do
  describe "#features" do
    subject { robot.features }

    context "when robot has current_maintenance_record" do
      let!(:robot) do
        Robot.make!
      end
      let!(:current_maintenance_record) do
        robot.maintain([Feature.make!])
      end

      it "returns its features" do
        is_expected.to match_array(current_maintenance_record.features)
      end
    end

    context "when robot doen't have current_maintenance_record" do
      let!(:robot) do
        Robot.make!
      end

      it { is_expected.to be_nil }
    end
  end
end
