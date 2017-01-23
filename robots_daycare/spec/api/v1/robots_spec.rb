require 'spec_helper'

describe "/api/v1/robots" do
  before do
    @robot = Fabricate(:robot)
  end

  context "show", :type => :api  do
    let(:url) { "/api/v1/robots/#{@robot.id}" }


    it "JSON" do
      get "#{url}"   
      @json_response = JSON.parse(last_response.body)
      @json_response["id"].should eql(@robot.id)
      last_response.status.should eql(200)
    end
  end
end