require_relative './spec_helper'
require_relative '../app/app'

describe App do
  context "get /" do
    it "should greet user" do
      get "/"
      last_response.should be_ok
    end
  end
end