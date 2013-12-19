require 'spec_helper'

describe "Guests" do
  before(:each) { Guest.clean }
  describe "GET /guests/:guest_name" do
    it 'shows the parameters of the guests saved' do
      put guest_path('XX1'), {guest: {size: '100cm', weight: '10kg'}}

      get guest_path('XX1')

      response.status.should be(200)
      response.body.should == {size: '100cm', weight: '10kg'}.to_json
    end
  end

  describe "PUT /guests/:guest_name" do
    it 'creates a guest when one dosent exist' do
      put guest_path('XX1'), {guest: {size: '100cm', weight: '10kg'}}

      get guest_path('XX1')
      response.body.should == {size: '100cm', weight: '10kg'}.to_json
    end

    it 'should update the attributes if guest already exists' do
      put guest_path('XX1'), {guest: {size: '100cm', weight: '10kg'}}
      
      put guest_path('XX1'), {guest: {size: '101cm', eyes: '2'}}

      get guest_path('XX1')
      response.body.should == {size: '101cm', weight: '10kg', eyes: '2'}.to_json
    end
  end
end
