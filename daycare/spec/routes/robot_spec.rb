require_relative '../../spec/spec_helper'

describe 'robot routes' do
  def response_json
    JSON.parse(last_response.body)
  end

  def eq!(a, b)
    expect(a).to eq(b)
  end

  def ok!
    expect(last_response).to be_ok
  end

  before :each do
    Robot.delete_all
    RobotInfo.delete_all
  end

  describe :index do
    it 'should return an empty list of robot' do
      get '/robots'
      ok!
      eq! response_json, []
    end
    it 'should return two robots with their name and last_update date' do
      r1 = generate_robot({})
      r2 = generate_robot({})
      get '/robots'
      ok!
      eq! response_json.count, 2
      eq! response_json.first['name'], r1.name
      eq! response_json.first['last_update'], r1.last_update
      eq! response_json.second['name'], r2.name
      eq! response_json.second['last_update'], r2.last_update
    end
  end

  describe :show do
    it 'displays the robots attributes' do
      r1 = generate_robot({})
      r2 = generate_robot({some: 'data', even: 'more'})
      get "/robots/#{r1.name}"
      ok!
      eq! response_json, r1.robot_info.info
      get "/robots/#{r2.name}"
      ok!
      eq! response_json, r2.robot_info.info
    end
  end
  describe :delete do
    it 'deletes the robot' do
      r1 = generate_robot({})
      delete "/robots/#{r1.name}"
      ok!
      eq! Robot.find_by_id(r1.id), nil
    end
  end
  describe :create do
    it 'updates the robot' do
      attrs = {'some' => 'where', 'over' => 'there'}
      post "/robots", attrs.to_json
      eq! last_response.status, 201
      eq! attrs, Robot.find(response_json['id']).robot_info.info
    end
  end

  describe :update do
    it 'updates the robot' do
      r1 = generate_robot({})
      attrs = {'some' => 'where', 'over' => 'there'}
      put "/robots/#{r1.name}", attrs.to_json
      ok!
      eq! attrs, Robot.find(response_json['id']).robot_info.info
    end

    it 'merges the attributes' do
      r1 = generate_robot({'hi' => 'there'})
      attrs = {'some' => 'where', 'over' => 'there'}
      put "/robots/#{r1.name}", attrs.to_json
      ok!
      before_update = r1.robot_info.info
      after_update = Robot.find(response_json['id']).robot_info.info
      eq! before_update.merge(attrs), after_update
    end
    it 'updates with new attribute values' do
      r1 = generate_robot({'some' => 'time'})
      attrs = {'some' => 'where'}
      put "/robots/#{r1.name}", attrs.to_json
      ok!
      before_update = r1.robot_info.info
      after_update = Robot.find(response_json['id']).robot_info.info
      eq! before_update.merge(attrs), after_update
    end
    it 'does not update anything if attributes are the same' do
      attrs = {a: '1'}
      r1 = generate_robot attrs
      put "/robots/#{r1.name}", attrs.to_json
      ok!
      eq! Robot.find(response_json['id']).robot_info, r1.robot_info
    end
  end
  describe :history do
    it 'displays the robot creation' do
      attrs = {'a'=>1, 'c' => true}
      r1 = generate_robot(attrs)
      get "/robots/#{r1.name}/history"
      ok!
      eq! response_json.count, 1
      eq! response_json[0]['type'], 'create'
      attrs.each do |k, v|
        eq! response_json[0]['changes'][k.to_s], [nil, v]
      end
    end
    describe :updates do
      it 'should not show any changes in history after an empty update' do
        attrs = {'a'=>1, 'c' => true}
        r1 = generate_robot(attrs)
        put "/robots/#{r1.name}", {}.to_json
        get "/robots/#{r1.name}/history"
        ok!
        eq! response_json.count, 1
        eq! response_json[0]['type'], 'create'
        attrs.each do |k, v|
          eq! response_json[0]['changes'][k.to_s], [nil, v]
        end
      end
      it 'should show changes in history after update with new attributes' do
        attrs = {'a'=>1, 'c' => true}
        r1 = generate_robot(attrs)
        put "/robots/#{r1.name}", {'c' => 'some value'}.to_json
        get "/robots/#{r1.name}/history"
        ok!
        eq! response_json.count, 2
        eq! response_json[0]['type'], 'create'
        attrs.each do |k, v|
          eq! response_json[0]['changes'][k.to_s], [nil, v]
        end
        eq! response_json[1]['type'], 'update'
        eq! response_json[1]['changes']['c'], [true, 'some value']
      end
    end
  end
end

def generate_robot(attr)
  Robot.create(robot_info: RobotInfo.new(info: attr))
end
