require 'spec_helper'

describe Guest do
  context '.find_or_initialize' do
    it 'should return a new Guest object' do
      guest = Guest.find_or_initialize('X2')

      expect(guest.attributes).to eql({})
      expect(guest.name).to eql('X2')
    end
  end

end
