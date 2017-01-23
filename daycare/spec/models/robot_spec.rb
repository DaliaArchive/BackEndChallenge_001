require_relative '../../spec/spec_helper'

describe Robot do
  before :each do
    Robot.delete_all
    RobotInfo.delete_all
  end
  before :each do

  end

  describe :validation do
    context :robot_info do
      it 'creates a Robot when RobotInfo is given' do
        robot = Robot.create(robot_info: RobotInfo.new(info: {}))
        expect(robot.errors.present?).to be(false)
      end
      it 'does not create a Robot without RobotInfo' do
        expect(Robot.create.errors.present?).to be(true)
      end
    end
  end
  describe :history do
    before :each do
      @robot = Robot.create(robot_info: RobotInfo.new(info: {}))
      @key = 'some'
      @value = 'change'
    end
    it 'generates one entry in history for creation' do
      expect(@robot.history.count).to eq(1)
      expect(@robot.history.first[:changes]).to eq({})
    end
    describe 'multiple revisions' do
      before :each do
        @robot.update(robot_info: RobotInfo.new(info: {@key => @value}))
      end
      it 'creates a new revision for the robot and maintains the old copy' do
        expect(@robot.robot_info.info[@key]).to eq(@value) #check copy in memory
        expect(Robot.find(@robot.id).robot_info.info[@key]).to eq(@value) #check copy in database
        revisions = RobotInfo.unscoped.where(robot_id: @robot.id)
        expect(revisions.count).to eq(2)
        expect(revisions.first.info).to eq({})
        expect(revisions.second.info).to eq(@robot.robot_info.info)
      end

      it 'generates a history entry for update' do
        expect(@robot.history.count).to eq(2)
      end
      it "generates a history entry for update with change from nil to #{@value}" do
        expect(@robot.history.second[:changes]).to eq({@key => [nil, @value]})
      end
    end
  end
end

