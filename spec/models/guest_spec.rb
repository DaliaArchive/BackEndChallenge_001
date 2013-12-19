require 'spec_helper'

describe Guest do
  before { 
    Guest.clean
  }
  context '.find_or_initialize' do
    it 'should return a new Guest if not found' do
      guest = Guest.find_or_initialize('X2')

      expect(guest.attributes).to eql({})
      expect(guest.name).to eql('X2')
    end

    it 'should return the saved Guest, when found' do
      Guest.new(name: 'X3', attributes: {age: 1}).save!

      guest = Guest.find_or_initialize('X3')

      expect(guest.attributes).to eql("age" => 1)
      expect(guest.name).to eql('X3')
    end
  end

  context 'initialize' do
    it 'should assign attributes from params' do
      guest = Guest.new(attributes: {test: "OK"})
      
      expect(guest.attributes).to eql("test" => "OK")
    end

    it 'should assign attributes as empty hash if not passed in params' do
      guest = Guest.new({})
      
      expect(guest.attributes).to eql({})
    end

    it 'should accept string keys for params hash' do
      guest = Guest.new("attributes" => {test: "OK"})


      expect(guest.attributes).to eql("test" => "OK")
    end
  end

end
