require 'spec_helper'

describe GuestsController do
  describe '#update' do
    it 'should find or create a guest and update his attributes' do
      put :update, name: 'XX11', guest: {age: "100"}

      person = Guest.find('XX11')
      expect(person.name).to eql('XX11')
      expect(person.attributes).to eql("age" => "100")
      expect(response.body).to be_empty
    end
  end

  describe '#show' do
    it 'should find an existing guest' do
      guest = Guest.new(name: 'R2D2', attributes: {height: '100cm'})
      guest.save!

      get :show, name: 'R2D2'

      expect(response.body).to eq({height: '100cm'}.to_json)
    end
  end

  describe '#index' do
    xit 'should list all the guests' do
      guest1 = Guest.new(name: 'R2D2', attributes: {height: '100cm'})
      guest1.save!

      guest2 = Guest.new(name: 'OTHERR2D2', attributes: {height: '102cm'})
      guest2.save!

      get :index

      expect(response.body).to eq([{name: guest1.name, last_updated: guest1.last_updated},
                                   {name: guest2.name, last_updated: guest2.last_updated}])
    end
  end


  describe '#histroy' do
    xit 'should get the history of a guest' do
      guest = Guest.new(name: 'R2D2', attributes: {height: '100cm'})
      guest.save!

      get :history, name: 'R2D2'

      expect(assigns(:history)).to eq(guest.history)
      expect(assigns(:history).count).to eq(1)
    end
  end
end
