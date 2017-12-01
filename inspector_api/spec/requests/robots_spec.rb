require 'rails_helper'

RSpec.describe 'Inspector API', type: :request do
  let(:robot){ create(:robot, name: "XX1") }

  describe 'GET /robots' do
    let!(:robots) { create_list(:robot, 2) }
    before { get '/robots'}

    it 'returns robots' do
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end

    it 'return status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /robots/:name' do
    let(:send_attributes) do 
      {
        properties:{
          'color'=> 'dirty white',
          'age'=> '124years',
          'number of eyes' => '1',
          'number of antenna' => '2'
        }
      }  
    end

    context 'when robot exists' do
      it 'returns status code 204' do
        put "/robots/#{robot.name}", params: send_attributes
        expect(response).to have_http_status(204)
      end

      it 'updates the robot' do
        put "/robots/#{robot.name}", params: send_attributes
        updated_robot = Robot.find_by_name(robot.name)
        expect(updated_robot.properties).to match(
          {
          'size'=> '100kg',
          'weight'=> '10kg',
          'status'=> 'good condition',
          'color'=> 'dirty white',
          'age'=> '124years',
          'number of eyes' => '1',
          'number of antenna' => '2'
        })
      end
    end

    context 'when the robot does not exist' do
      let(:robot_name){'XXY'}

      it 'creates the robot' do
        expect { 
          put "/robots/#{robot_name}", params: send_attributes
        }.to change { Robot.count }
      end

      it 'updates properties' do
        put "/robots/#{robot_name}", params: send_attributes
        created_robot = Robot.find_by_name(robot_name)
        expect(created_robot.properties).to match(
          {
          'color'=> 'dirty white',
          'age'=> '124years',
          'number of eyes' => '1',
          'number of antenna' => '2'
        })
      end
    end
  end

  describe 'GET /robots/:name' do
    context 'when robot exists' do
      before { get "/robots/#{robot.name}" }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the robot' do
        expect(json).to match(
          {
          "size" => '100kg',
          "weight" => '10kg',
          "status" => 'good condition',
          "color" => 'white',
          "age" => '123years'
          }
        )
      end
    end

    context 'when the robot does not exist' do

      before { get "/robots/XXZ" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /robots/:name/history' do
    let(:send_attributes) do 
      {
        properties:{
          'color'=> 'dirty white',
          'age'=> '124years',
          'number of eyes' => '1',
          'number of antenna' => '2'
        }
      }
    end
    let(:robot_name){ "test_robot"}
    context 'when the robot created' do

      it 'creates the changelog' do
        expect { 
          put "/robots/#{robot_name}", params: send_attributes
        }.to change { RobotChangelog.count }
      end

      it 'contains change props' do
        put "/robots/#{robot_name}", params: send_attributes
        get "/robots/#{robot_name}/history"
        expect(json.map { |e| e["changes"].values }).to match(
            [ [{}],
              [
                { "color"=>[nil, "dirty white"],
                  "age"=>[nil, "124years"],
                  "number of eyes"=>[nil, "1"],
                  "number of antenna"=>[nil, "2"]
                }
              ]
            ]
        )
      end
          
    end 
  end
end