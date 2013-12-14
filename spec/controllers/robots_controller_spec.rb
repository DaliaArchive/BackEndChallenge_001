require 'spec_helper'

describe RobotsController do

  describe 'create_or_update' do

    it 'should save the details for a non-existing robot with the given id and respond with a 201' do

      Robot.where(:id => 'XX1').count.should == 0

      post :create_or_update, :robot => { :id => 'XX1', :weight => { :value => 100, :unit => 'cm'}, :color => :white}

      Robot.where(:id => 'XX1').count.should == 1
      response.status.should == 201
    end

  end

end
