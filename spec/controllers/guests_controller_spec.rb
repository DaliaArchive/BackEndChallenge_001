require 'spec_helper'

describe GuestsController do
  describe '#update' do
    xit 'should find or create a guest and update his attributes' do
      put :update, {name: 'XX11', guest: {age: 100}}

      person = Guest.find('XX11')
      expect(person.name).to eql('XX11') 
      expect(person.attributes).to eql(age: 100)
    end
  end
end
