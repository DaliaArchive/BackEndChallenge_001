require_relative 'spec_helper'
require_relative '../app/public_app'
require 'mongo'


describe PublicApp do
  def app
    PublicApp
  end

  context "get /" do
    it "should greet user" do
      get "/"
      last_response.should be_ok
    end
  end
end
