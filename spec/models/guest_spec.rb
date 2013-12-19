require 'spec_helper'

describe Guest do
  before { 
    Guest.clean
  }
  context '.find_or_initialize' do
    it 'should return a new Guest if not found' do
      guest = Guest.find_or_initialize('X2')

      expect(guest.attributes).to eq({})
      expect(guest.name).to eq('X2')
    end

    it 'should return the saved Guest, when found' do
      Guest.new(name: 'X3', attributes: {age: 1}).save!

      guest = Guest.find_or_initialize('X3')

      expect(guest.attributes).to eq("age" => 1)
      expect(guest.name).to eq('X3')
    end
  end

  context '.find' do
    it 'should return null if not found' do
      expect(Guest.find('X2')).to be_nil
    end

    it 'should return the saved Guest, when found' do
      guest = Guest.new(name: 'X3', attributes: {age: 1})
      guest.save!

      expect(Guest.find('X3')).to eq(guest)
    end
  end

  context '.eql?' do
    subject(:guest) { Guest.new(name: 'Bob', attributes: {eyes: 2})}
    it 'should be equal to another guest with the same name and attributes' do
      expect(guest).to eq(Guest.new(name: 'Bob', attributes: {eyes: 2}))
    end

    it 'should not be equal when name or attributes or type dont match' do
      expect(guest).not_to eq(Guest.new(name: 'Bob1', attributes: {eyes: 2}))
      expect(guest).not_to eq(Guest.new(name: 'Bob', attributes: {eyes: 3}))
      expect(guest).not_to eq("a string")
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

  context '#merge_attributes' do
    it 'should merge attributes with existing attributes' do
      guest = Guest.new(attributes: {eyes: 1})

      guest.merge_attributes(gps: true)

      expect(guest).to eq(Guest.new(attributes: {eyes:1, gps: true}))
    end
  end

  context '#save!' do
    it 'should create new record if its a new guest record' do
      guest = Guest.new(name: 'TSTBOT', attributes: {eyes: 101}) 

      guest.save!

      expect(Guest.find('TSTBOT')).to eq(guest)
    end

    it 'should update the existing guest' do
      Guest.new(name: 'TSTBOT', attributes: {eyes: 101}).save!
      guest = Guest.find('TSTBOT')
      guest.merge_attributes(eyes: 99)

      guest.save!

      guest = Guest.find('TSTBOT')
      expect(guest).to eq(Guest.new(name: 'TSTBOT', attributes: {eyes: 99}))
    end
  end

end
