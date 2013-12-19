require "spec_helper"

describe GuestsController do
  describe "routing" do
    it "routes to #index" do
      get("/guests").should route_to("guests#index")
    end

    it "routes to #show" do
      get("/guests/1").should route_to("guests#show", :name => "1")
    end

    it "routes to #update for patch" do
      patch("/guests/XX").should route_to("guests#update", :name => "XX")
    end

    it "routes to #update for put" do
      put("/guests/X31").should route_to("guests#update", :name => "X31")
    end

    it 'routes to #history for get history' do
      get('/guests/X32/history').should route_to('guests#history', name: 'X32')
    end
  end
end
