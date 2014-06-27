require "spec_helper"

describe RobotsController do

	describe "Routing" do
		describe "#index" do
			specify { get("/robots").should route_to("robots#index") }
		end

		describe "#show" do
			specify { get("/robots/:name").should route_to("robots#show", name: ":name" ) }
		end

		describe "#update" do
			specify { put("robots/update").should route_to("robots#update") }
		end

		describe "#history" do
			specify { get("robots/:name/history").should route_to("robots#history", name: ":name") }
		end
	end
	
end
