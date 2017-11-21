require 'rails_helper'

RSpec.describe GuestsController, type: :controller do

  describe "POST #update" do
    before do
      Timecop.freeze(Time.utc(2113, 12, 19, 12, 0, 0))
    end

    after do
      Timecop.return
    end

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

      it "saves an entry in the guest's history with type create" do
          post :update, params: { name: 'nanobot',
                                  custom_attributes: { 'height' => '0.1mm'} }
          guest = Guest.find_by_name('nanobot')
          expect(guest.history.length).to eq 1
          expect(guest.history.first).to eq('type' => 'create',
                                            'datetime' => '2113-12-19T12:00:00.000Z',
                                            'changes' => { 'old' => {},
                                                           'new' => { 'height' => '0.1mm' } })
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

      it "saves an entry in the guest's history with type update" do
        post :update, params: { name: guest.name, custom_attributes: { attitude: 'indifferent' } }
        guest.reload
        expect(guest.history.length).to eq 1
        expect(guest.history.first).to eq('type' => 'update',
                                          'datetime' => '2113-12-19T12:00:00.000Z',
                                          'changes' => { 'old' => {'shape' => 'garbage_can', 'attitude' => 'snarky'},
                                                         'new' => {'shape' => 'garbage_can', 'attitude' => 'indifferent'} })
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
      guests = (0..2).map do |i|
        Fabricate(:guest, history: [{'datetime' => '2113-12-19'},
                                    {'datetime' => '2113-12-20'},
                                    {'datetime' => '2113-12-18'}])
      end
      get :index

      body = JSON.parse(response.body)
      expect(body['guests'].length).to eq 3

      guests.each_with_index do |guest, i|
        guest_json = body['guests'][i]
        expect(guest_json['id']).to eq guest.id
        expect(guest_json['name']).to eq guest.name
        expect(guest_json['last_update']).to eq '2113-12-20'
      end
    end
  end

  describe "GET #history" do
    it "returns http not found when given a bad guest name" do
      get :history, params: { name: 'foo' }
      expect(response).to have_http_status(:not_found)
    end

    it "returns the history of a guest" do
      guest = Fabricate(:guest, name: "scholar_bot", history: [{'type' => 'create',
                                                                'datetime' => '2113-12-19T12:00:00.000Z',
                                                                'changes' => { 'old' => {},
                                                                               'new' => { 'foo' => 'bar' } } }])
      get :history, params: { name: guest.name }
      body = JSON.parse(response.body)
      expect(body).to eq([{'type' => 'create',
                                     'datetime' => '2113-12-19T12:00:00.000Z',
                                     'changes' => { 'old' => {},
                                                    'new' => { 'foo' => 'bar' } } }])
    end
  end

end
