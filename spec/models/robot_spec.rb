require 'rails_helper'

RSpec.describe Robot, type: :model do
  let!(:robot) { create(:robot, attributes: { age: '123 years', color: 'white' }) }
  let(:attributes) { { age: '124 years', color: 'dirty white' } }

  describe '.attributes=' do
    it 'should accept a Hash of attributes and set them to the record' do
      expect(robot.attributes).to include('age')
      expect(robot['age']).to eq('123 years')
      expect(robot.attributes).to include('color')
      expect(robot['color']).to eq('white')
    end
  end

  describe '.set_last_update' do
    it 'should set last_update attribute to current time when record is saved' do
      expect(robot.last_update).to be_present

      sleep 1.second

      expect { robot.update(age: '124 years') }.to change(robot, :last_update)
    end
  end

  describe '.record_history' do
    it 'should create a History every time record changes' do
      expect { robot.update(attributes: attributes) }.to change(robot.histories, :count).from(1).to(2)
    end

    it 'should add AttributeChanges to created History for each changed attribute' do
      expect(robot.histories.count).to eq(1)
      expect(robot.histories[0].attribute_changes.count).to eq(3)
      expect { robot.update(attributes: attributes) }.to change(robot.histories, :count).from(1).to(2)
      expect(robot.histories[1].attribute_changes.count).to eq(2)
    end

    it 'should set History created_at to current time of Robot change' do
      expect(robot.histories.count).to eq(1)
      expect(robot.histories[0].created_at).to eq(robot.last_update)

      sleep 1.second

      expect { robot.update(attributes: attributes) }.to change(robot.histories, :count).from(1).to(2)
      expect(robot.histories[1].created_at).to eq(robot.last_update)
    end

    it 'should set History type to create is Robot is a new record' do
      expect(robot.histories.count).to eq(1)
      expect(robot.histories[0].type).to eq('create')
    end

    it 'should set History type to update is Robot is changed' do
      expect { robot.update(attributes: attributes) }.to change(robot.histories, :count).from(1).to(2)
      expect(robot.histories[1].type).to eq('update')
    end

    it 'should store attribute name, attribute old and new values to each AttributeChange' do
      expect(robot.histories.count).to eq(1)
      expect { robot.histories[0].attribute_changes.find_by(attribute_name: 'age') }.not_to raise_error
      expect(robot.histories[0].attribute_changes.find_by(attribute_name: 'age').old_value).to eq(nil)
      expect(robot.histories[0].attribute_changes.find_by(attribute_name: 'age').new_value).to eq('123 years')
      expect { robot.histories[0].attribute_changes.find_by(attribute_name: 'color') }.not_to raise_error
      expect(robot.histories[0].attribute_changes.find_by(attribute_name: 'color').old_value).to eq(nil)
      expect(robot.histories[0].attribute_changes.find_by(attribute_name: 'color').new_value).to eq('white')

      expect { robot.update(attributes: attributes) }.to change(robot.histories, :count).from(1).to(2)

      expect(robot.histories.count).to eq(2)
      expect { robot.histories[1].attribute_changes.find_by(attribute_name: 'age') }.not_to raise_error
      expect(robot.histories[1].attribute_changes.find_by(attribute_name: 'age').old_value).to eq('123 years')
      expect(robot.histories[1].attribute_changes.find_by(attribute_name: 'age').new_value).to eq('124 years')
      expect { robot.histories[1].attribute_changes.find_by(attribute_name: 'color') }.not_to raise_error
      expect(robot.histories[1].attribute_changes.find_by(attribute_name: 'color').old_value).to eq('white')
      expect(robot.histories[1].attribute_changes.find_by(attribute_name: 'color').new_value).to eq('dirty white')
    end
  end
end
