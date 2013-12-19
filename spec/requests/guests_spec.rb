require 'spec_helper'

describe "Guests" do
   describe "GET /guests/:guest_name" do
    xit 'shows the parameters of the guests saved' do
      put guest_path('XX1'), {size: '100cm', weight: '10kg'}

      get guest_path('XX1')

      response.status.should be(200)
      response.body.should == {size: '100cm', weight: '10kg'}.to_json
    end
  end
end
