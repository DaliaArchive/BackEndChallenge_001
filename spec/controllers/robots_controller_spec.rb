require 'rails_helper'

describe RobotsController, type: :controller do
  describe "GET #index" do
    let!(:robot) { Robot.make! }

    before { get :index, format: 'json' }

    it { expect(response).to be_ok }
  end

  describe "GET #show" do
    let!(:robot) { Robot.make! }

    before do
      get :show, { id: robot.to_param, format: 'json' }
    end

    it "assigns the requested robot as @robot" do
      expect(assigns(:robot)).to eq(robot)
    end
  end

  describe "POST #maintain" do
    context "with invalid params" do
      it { expect{ post(:maintain, {}) }.to raise_error }
    end

    context "when robot doesn't exist" do
      let(:robot_params) do
        { name: 'R2-D2' }
      end
      let(:features_params) do
        [{ key: 'tall', value: '43 inches' }]
      end

      before do
        params = { robot: robot_params.merge(features: features_params) , format: 'json' }
        post :maintain, params
      end

      it { expect(response).to be_ok }

      it "maintains robot" do
        expect(Robot.last.name).to eq(robot_params[:name])
      end

      it "maintained robot has given feature" do
        params = features_params.first
        expected_feature = assigns(:robot).features.first
        expect(expected_feature.key).to eq(params[:key])
        expect(expected_feature.value).to eq(params[:value])
      end
    end

    context "when robot already exists" do
      let(:robot) { Robot.make! }
      let(:feature) { Feature.new(key: 'color', value: 'blue') }
      let(:features_params) do
        [{ key: 'color', value: 'red' }]
      end

      before do
        robot.maintain([feature])

        params = { robot: { id: robot.id, features: features_params} , format: 'json' }
        post :maintain, params
      end

      it { expect(response).to be_ok }

      it "updates features" do
        params = features_params.first
        expected_feature = assigns(:robot).features.first
        expect(expected_feature.key).to eq(params[:key])
        expect(expected_feature.value).to eq(params[:value])
      end
    end
  end
end
