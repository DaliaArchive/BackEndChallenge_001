require 'rails_helper'

RSpec.describe RobotsController, type: :controller do

  let!(:robot) { create(:robot, attributes: { age: '123 years', color: 'white' }) }

  describe "#index" do

    it 'should return a list of Robots' do
      get :index
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body.size).to eq(1)
      expect(body[0]).to include('name')
      expect(body[0]).to include('id')
    end
  end

  describe "#show" do
    it 'should the Robot attributes' do
      get :show, params: { id: robot.id }
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body).to include('name')
      expect(body).to include('age')
      expect(body).to include('color')
      expect(body['name']).to eq('R2D2')
      expect(body['age']).to eq('123 years')
      expect(body['color']).to eq('white')
    end
  end

  describe "#update" do
    it 'should update the Robot attributes' do
      put :update, params: { id: robot.id, robot: { attributes: { age: '124 years', color: 'dirty white', antennas: 1, eyes: 2 } } }
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body).to include('name')
      expect(body).to include('age')
      expect(body).to include('color')
      expect(body).to include('antennas')
      expect(body).to include('eyes')
      expect(body['name']).to eq('R2D2')
      expect(body['age']).to eq('124 years')
      expect(body['color']).to eq('dirty white')
      expect(body['antennas']).to eq('1')
      expect(body['eyes']).to eq('2')
    end
  end
end
