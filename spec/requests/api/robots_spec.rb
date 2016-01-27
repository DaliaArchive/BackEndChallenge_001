require 'rails_helper'

describe Api::RobotsController, :type => :controller do

  describe "GET #show" do

    before do
      @robot = Robot.create(name:"XX1")
      @revision = Revision.create(type: "create")
      @feature = Feature.create(name:"color", value: "white")
      @revision.features << @feature
      @robot.revisions << @revision
    end

    context "robot exists" do

      it "retrieves robot's attributes" do

        get :show, id: @robot.name, format: :json
        json = JSON.parse(response.body)

        expect(response).to be_success

        expect(json['color']).to eq('white')

      end
    end

    context "robot doesn't exist" do

      it "return an error message" do

        get :show, id: "XX3", format: :json
        json = JSON.parse(response.body)

        expect(response.status).to eq(404)

        expect(json['error']).to eq('Robot not found')

      end

    end
  end

  describe "GET #index" do

    context "robots are present in the DB" do

      before do
        @robot = Robot.create(name:"XX1")
        @revision = Revision.create(type: "create")
        @feature = Feature.create(name:"color", value: "white")
        @revision.features << @feature
        @robot.revisions << @revision
        @robot2 = Robot.create(name:"XX2")
        @revision = Revision.create(type: "create")
        @feature = Feature.create(name:"color", value: "red")
        @revision.features << @feature
        @robot2.revisions << @revision
      end

      it "returns a list of robots" do

        get :index,  format: :json
        json = JSON.parse(response.body)

        expect(response).to be_success

        expect(json[0]['name']).to eq('XX1')
        expect(json[1]['name']).to eq('XX2')

      end

    end

    context "there are no robots in the DB" do

      it "returns an empty list" do

        get :index,  format: :json
        json = JSON.parse(response.body)

        expect(response).to be_success

        expect(json.size).to eq(0)

      end
    end

  end

  describe "PUT #update" do

    context "creating a robot with features" do

      it "creates the robot and assign the features" do

        put :update,id: "XX1", color: "blue", weight: "90kg",  format: :json
        json = JSON.parse(response.body)

        expect(response).to be_success

        expect(Robot.all.count).to eq(1)

        expect(json['color']).to eq('blue')
        expect(json['weight']).to eq('90kg')

        @robot= Robot.first

        expect(@robot.name).to eq("XX1")
        expect(@robot.current_features["color"]).to eq("blue")
        expect(@robot.current_features["weight"]).to eq("90kg")

      end

    end

    context "creates a robot without features" do

      it "creates the robot correctly" do

        put :update,id: "XX1", format: :json
        json = JSON.parse(response.body)

        expect(response).to be_success

        expect(Robot.all.count).to eq(1)

        expect(Robot.first.name).to eq("XX1")

      end

    end

    context "modify a robot's feature with a new value" do

      before do

        @robot = Robot.create(name:"XX1")
        @revision = Revision.create(type: "create")
        @feature = Feature.create(name:"color", value: "white")
        @feature2 = Feature.create(name: "weight", value: "50kg")
        @revision.features << @feature2
        @revision.features << @feature
        @robot.revisions << @revision

      end

      it "update the feature correctly" do

        put :update,id: "XX1", color: "blue", weight: "90kg",  format: :json
        json = JSON.parse(response.body)

        expect(response).to be_success

        expect(json['color']).to eq('blue')
        expect(json['weight']).to eq('90kg')

        @robot= Robot.first

        expect(@robot.name).to eq("XX1")
        expect(@robot.current_features["color"]).to eq("blue")
        expect(@robot.current_features["weight"]).to eq("90kg")

      end

    end

    context "modify a robot's feature with the same value" do

      before do
        @robot = Robot.create(name:"XX1")
        @revision = Revision.create(type: "create")
        @feature = Feature.create(name:"color", value: "white")
        @revision.features << @feature
        @robot.revisions << @revision
      end

      it "doesn't change the robot's feature" do

        put :update,id: "XX1", color: "white",format: :json
        json = JSON.parse(response.body)

        expect(response).to be_success

        expect(json['color']).to eq('white')

        @robot= Robot.first


        expect(@robot.current_features["color"]).to eq("white")
        expect(@robot.current_features.count).to eq(1)

      end

    end

  end

  describe "GET #history" do

    context "Robot has revisions" do

      before do
        @robot = Robot.create(name:"XX1")
        @revision1 = Revision.create(type: "create")
        @feature = Feature.create(name:"color", value: "white")
        @revision1.features << @feature
        @robot.revisions << @revision1
        sleep(1)
        @revision2 = Revision.create(type: "update")
        @feature = Feature.create(name:"color", value:"black")
        @revision2.features << @feature
        @feature = Feature.create(name:"weight", value: "90kg")
        @revision2.features << @feature
        @robot.revisions << @revision2
      end

      it "retrieves correctly the list of changes" do

        get :history,id: "XX1",  format: :json
        json = JSON.parse(response.body)

        expect(response).to be_success

        expect(json.keys.size).to eq(2)

        created_at = @revision1.created_at.to_formatted_s(:db)

        @first_revision = json[created_at]

        expect(@first_revision["type"]).to eq("create")

        expected_string = "color: [] -> [white]"

        expect(@first_revision["changes"][0]).to eq(expected_string)

        created_at = @revision2.created_at.to_formatted_s(:db)

        @second_revision = json[created_at]

        expected_string_1 = "color: [white] -> [black]"

        expected_string_2 = "weight: [] -> [90kg]"

        expect(@second_revision["changes"].include?(expected_string_1)).to eq(true)

        expect(@second_revision["changes"].include?(expected_string_2)).to eq(true)

      end


    end

    context "Robot doesn't have revisions" do

      before do
        @robot = Robot.create(name:"XX1")
      end

      it "retrives an empty response" do

        get :history,id: "XX1",  format: :json
        json = JSON.parse(response.body)

        expect(response).to be_success

        expect(json).to be_empty

      end

    end

  end

end



