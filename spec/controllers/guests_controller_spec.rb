require 'rails_helper'

RSpec.describe GuestsController, type: :controller do

  describe "POST #update" do
    it "returns http success" do
      post :update, params: { name: 'foo' }
      expect(response).to have_http_status(400)
    end

    context "when record doesn't exist" do
      it "creates it with given attributes" do
        post :update, params: { name: 'nanobot',
                                custom_attributes: { 'height' => '0.1mm', 'number of eyes' => '142' } }
        expect(response).to have_http_status(:success)
        guest = Guest.find_by_name('nanobot')
        expect(guest).not_to be_nil
        expect(guest.custom_attributes).to eq('height' => '0.1mm', 'number of eyes' => '142')
      end
    end

    context "when record already exists" do
      let!(:guest) { Fabricate(:guest, name: 'r2d2', custom_attributes: { shape: 'garbage_can', attitude: 'snarky' }) }

      it "updates the existing record" do
        post :update, params: { name: guest.name, custom_attributes: { height: '1m' } }
        guest.reload
        expect(guest.custom_attributes).to eq('shape' => 'garbage_can', 'attitude' => 'snarky', 'height' => '1m')
      end

      it "updates values that already exist" do
        post :update, params: { name: guest.name, custom_attributes: { attitude: 'indifferent' } }
        guest.reload
        expect(guest.custom_attributes).to eq('shape' => 'garbage_can', 'attitude' => 'indifferent')
      end
    end

  end

  describe "GET #show" do
    it "returns http not found when given a bad guest name" do
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
    it "returns http not found when given a bad guest name" do
      get :history, params: { name: 'foo' }
      expect(response).to have_http_status(:not_found)
    end
  end

end
