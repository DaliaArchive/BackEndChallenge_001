require 'rails_helper'

RSpec.describe GuestsController, type: :controller do

  describe "POST #update" do
    it "returns http success" do
      post :update, params: { name: 'foo' }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { name: 'foo' }
      expect(response).to have_http_status(:not_found)
    end

    it "returns the guests information" do
      guest = Fabricate(:guest)
      get :show, params: { name: guest.name }
      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body['name']).to eq guest.name
      expect(body['custom_attributes']).to eq guest.custom_attributes
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns all of the guests" do
      guests = (0..2).map {|i| Fabricate(:guest) }
      get :index

      body = JSON.parse(response.body)
      expect(body['guests'].length).to eq 3

      guests.each_with_index do |guest, i|
        guest_json = body['guests'][i]
        expect(guest_json['id']).to eq guest.id
        expect(guest_json['name']).to eq guest.name
      end
    end
  end

  describe "GET #history" do
    it "returns http success" do
      get :history, params: { name: 'foo' }
      expect(response).to have_http_status(:success)
    end
  end

end
