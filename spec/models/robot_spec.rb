require 'rails_helper'

RSpec.describe Robot, type: :model do
  let!(:robot) { create(:robot, attributes: { age: '123 years', color: 'white' }) }

  describe '.attributes=' do
    it 'should accept a Hash of attributes and set them to the record' do
      expect(robot.attributes).to include('age')
      expect(robot['age']).to eq('123 years')
      expect(robot.attributes).to include('color')
      expect(robot['color']).to eq('white')
    end
  end
end
