require 'rails_helper'

RSpec.describe HistoriesController, type: :controller do
  describe '#index' do
    let!(:robot) { create(:robot, attributes: { age: '123 years', color: 'white' }) }
    let(:attributes) { { age: '124 years', color: 'dirty white' } }

    it 'should render Robot changes history' do
      create_date = robot.last_update.strftime "%Y-%m-%d %H:%M:%S"
      sleep 1.second
      robot.update(attributes)
      update_date = robot.last_update.strftime "%Y-%m-%d %H:%M:%S"

      get :index, params: { robot_id: robot.id }

      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body.size).to eq(2)
      expect(body[0].keys).to include(create_date)
      expect(body[0][create_date].keys).to include('type')
      expect(body[0][create_date]['type']).to eq('create')
      expect(body[0][create_date].keys).to include('changes')
      expect(body[0][create_date]['changes'].size).to eq(3)
      expect(body[0][create_date]['changes'][0].keys).to include('name')
      expect(body[0][create_date]['changes'][0]['name']).to eq([nil, 'R2D2'])
      expect(body[0][create_date]['changes'][1].keys).to include('age')
      expect(body[0][create_date]['changes'][1]['age']).to eq([nil, '123 years'])
      expect(body[0][create_date]['changes'][2].keys).to include('color')
      expect(body[0][create_date]['changes'][2]['color']).to eq([nil, 'white'])

      expect(body[1].keys).to include(update_date)
      expect(body[1][update_date].keys).to include('type')
      expect(body[1][update_date]['type']).to eq('update')
      expect(body[1][update_date].keys).to include('changes')
      expect(body[1][update_date]['changes'].size).to eq(2)
      expect(body[1][update_date]['changes'][0].keys).to include('age')
      expect(body[1][update_date]['changes'][0]['age']).to eq(['123 years', '124 years'])
      expect(body[1][update_date]['changes'][1].keys).to include('color')
      expect(body[1][update_date]['changes'][1]['color']).to eq(['white', 'dirty white'])
    end
  end
end
