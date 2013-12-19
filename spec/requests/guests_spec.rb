require 'spec_helper'

describe 'Guests' do
  before(:each) { Guest.clean }
  describe 'GET /guests/:guest_name' do
    it 'shows the parameters of the guests saved' do
      put guest_path('XX1'), {guest: {size: '100cm', weight: '10kg'}}

      get guest_path('XX1')

      expect(response.status).to eq(200)
      expect(response.body).to eq({size: '100cm', weight: '10kg'}.to_json)
    end
  end

  describe 'PUT /guests/:guest_name' do
    it 'creates a guest when one dosent exist' do
      put guest_path('XX1'), {guest: {size: '100cm', weight: '10kg'}}

      get guest_path('XX1')
      expect(response.body).to eq({size: '100cm', weight: '10kg'}.to_json)
    end

    it 'should update the attributes if guest already exists' do
      put guest_path('XX1'), {guest: {size: '100cm', weight: '10kg'}}
      
      put guest_path('XX1'), {guest: {size: '101cm', eyes: '2'}}

      get guest_path('XX1')
      expect(response.body).to eq({size: '101cm', weight: '10kg', eyes: '2'}.to_json)
    end
  end

  describe 'GET /guest/:guest_name/history' do
    xit 'gives the list of changes to the guest attributes' do
      Timecop.freeze(DateTime.parse('12 Dec 2234 13:04:12')) do
        put guest_path('XX1'), {guest: {size: '100cm', weight: '10kg'}}
      end 

      Timecop.freeze(DateTime.parse('12 Dec 2250 07:10:00')) do
        put guest_path('XX1'), {guest: {size: '100cm', weight: '4kg', ears: '1'}}
      end 

      get history_guest_path('XX1')
      expect(response.body).to eq([
        {timestamp: DateTime.parse('12 Dec 2234 13:04:12'),
         type: 'create',
         changes: [
           {attribute: 'size', old: nil, new: '100cm'},
           {attribute: 'weight', old: nil, new: '10kg'}
         ]
        },
        {timestamp: DateTime.parse('12 Dec 2250 07:10:00'),
         type: 'update',
         changes: [
           {attribute: 'weight', old: '10kg', new: '4kg'},
           {attribute: 'ears', old: nil, new: '1'}
         ]
        },
      ].to_json)



    end
  end
end
