require 'spec_helper'

describe RobotsController do

  describe 'create_or_update' do

    it 'should save the details for a non-existing robot and respond with a 200' do

      post :create_or_update, :robot => { :weight => { :value => 100, :unit => 'cm'}, :color => :white}

      Robot.where(:color => 'white').count.should == 1
      response.status.should == 200
      robot_from(response).id.should_not be_nil

    end


    it 'should save the details for a non-existing robot with the given id and respond with a 200' do

      Robot.where(:id => 'XX1').count.should == 0

      post :create_or_update, :robot => { :id => 'XX1', :weight => { :value => 100, :unit => 'cm'}, :color => :white}

      Robot.where(:id => 'XX1').count.should == 1
      response.status.should == 200
      robot_from(response).should == Robot.where(:id => 'XX1')[0]

    end


    it 'should update the details for an existing robot with the given id and respond with a 200' do

      Robot.create(:id => 'XX1', :color => :white)

      post :create_or_update, :robot => { :id => 'XX1', :color => :black}

      Robot.where(:id => 'XX1')[0][:color].should == 'black'
      response.status.should == 200
      robot_from(response).should == Robot.where(:id => 'XX1')[0]
    end

  end

  describe 'show' do

    it 'should render 200 with robot details for a valid robot id' do
      Robot.create(:id => 'XX1', :color => :white)

      get :show, {:id => 'XX1'}

      response.status.should == 200
      robot_from(response).should == Robot.where(:id => 'XX1')[0]
    end

    it 'should respond with a 400 for an invalid robot id' do
      get :show, {:id => 'XX1'}

      response.status.should == 400
      JSON.parse(response.body)['error_message'].should_not be_nil
    end

  end


  describe 'index' do

    it 'should return a list of all the robots with a 200 status' do
      Robot.create(:id => 'XX1', :color => :white)
      Robot.create(:id => 'XX2', :color => :white)

      get :index

      response.status.should == 200
      JSON.parse(response.body)['robots'].count.should == 2
    end

  end


  describe 'history' do

    it 'should return an audit trail for changes to a robot attributes excluding the id field' do
      post :create_or_update, :robot => { :id => 'XX1', :color => :black, :number_of_antennas => 1}
      get :history, {:id => 'XX1'}

      response.status.should == 200
      parsed_response = JSON.parse(response.body)
      changed_attribute_values = parsed_response['audit'][0]['changed_attribute_values']

      parsed_response['audit'][0]['robot_id'].should == 'XX1'
      parsed_response['audit'][0]['type'].should == 'create'
      parsed_response['audit'][0]['created_at'].should_not be_nil
      changed_attribute_values.size.should == 2
      changed_attribute_values['color'].should == '[] -> [ black ]'
      changed_attribute_values['number_of_antennas'].should == '[] -> [ 1 ]'

      post :create_or_update, :robot => { :id => 'XX1', :color => :white, :number_of_antennas => 1}

      get :history, {:id => 'XX1'}

      response.status.should == 200
      parsed_response = JSON.parse(response.body)
      changed_attribute_values = parsed_response['audit'][1]['changed_attribute_values']

      parsed_response['audit'].count.should == 2
      parsed_response['audit'][1]['robot_id'].should == 'XX1'
      parsed_response['audit'][1]['type'].should == 'update'
      parsed_response['audit'][1]['created_at'].should_not be_nil
      changed_attribute_values.size.should == 1
      changed_attribute_values['color'].should == '[black] -> [ white ]'
    end

  end

  def robot_from(response)
    Robot.new(JSON.parse(response.body)['robot'])
  end

end
