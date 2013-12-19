require 'spec_helper'

describe Guest do
  context '.find_or_initialize' do
    it 'should return a new Guest if not found' do
      guest = Guest.find_or_initialize('X2')

      expect(guest.attributes).to eq({})
      expect(guest.name).to eq('X2')
    end

    it 'should return the saved Guest, when found' do
      Guest.new(name: 'X3', attributes: {age: 1}).save!

      guest = Guest.find_or_initialize('X3')

      expect(guest.attributes).to eq('age' => 1)
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

  context 'equality' do
    subject(:guest) { Guest.new(name: 'Bob', attributes: {eyes: 2}) }
    it 'should be equal to another guest with the same name and attributes' do
      expect(guest).to eq(Guest.new(name: 'Bob', attributes: {eyes: 2}))
    end

    it 'should not be equal when name or attributes or type dont match' do
      expect(guest).not_to eq(Guest.new(name: 'Bob1', attributes: {eyes: 2}))
      expect(guest).not_to eq(Guest.new(name: 'Bob', attributes: {eyes: 3}))
      expect(guest).not_to eq('a string')
    end
  end

  context '#initialize' do
    it 'should assign attributes from params' do
      guest = Guest.new(attributes: {test: 'OK'})

      expect(guest.attributes).to eql('test' => 'OK')
    end

    it 'should assign attributes as empty hash if not passed in params' do
      guest = Guest.new({})

      expect(guest.attributes).to eql({})
    end

    it 'should accept string keys for params hash' do
      guest = Guest.new('attributes' => {test: 'OK'})


      expect(guest.attributes).to eql('test' => 'OK')
    end
  end

  context '#merge_attributes' do
    it 'should merge attributes with existing attributes' do
      guest = Guest.new(attributes: {eyes: 1})

      guest.merge_attributes(gps: true)

      expect(guest).to eq(Guest.new(attributes: {eyes: 1, gps: true}))
    end
  end

  context '#history' do
    xit 'should give the history for the guest' do
      guest = Guest.new(name: 'TSTBOT', attributes: {eyes: 101})
      guest.save!

      expect(guest.history).to eq(GuestHistory.find('TSTBOT'))
    end
  end

  context '#save!' do
    context 'new record' do
      it 'should save a new guest record' do
        guest = Guest.new(name: 'TSTBOT', attributes: {eyes: 101})

        guest.save!

        expect(Guest.find('TSTBOT')).to eq(guest)
      end

      it 'notify guest history about new record' do
        guest = Guest.new(name: 'TSTBOT', attributes: {eyes: 101})

        expect{guest.save!}.to change{guest.history.count}.by(1)

        history_record = guest.history.last
        expect(history_record.type).to eq('created')
        expect(history_record.guest_name).to eq('TSTBOT')
      end
    end

    context 'existing record' do
      it 'should update the existing guest' do
        Guest.new(name: 'TSTBOT', attributes: {eyes: 101}).save!
        guest = Guest.find('TSTBOT')
        guest.merge_attributes(eyes: 99)

        guest.save!

        guest = Guest.find('TSTBOT')
        expect(guest).to eq(Guest.new(name: 'TSTBOT', attributes: {eyes: 99}))
      end

      it 'notify guest history about updated record' do
        Guest.new(name: 'TSTBOT', attributes: {eyes: 101}).save!
        guest = Guest.find('TSTBOT')
        guest.merge_attributes(eyes: 99)

        expect{guest.save!}.to change{guest.history.count}.by(1)

        history_record = guest.history.last
        expect(history_record.type).to eq('updated')
        expect(history_record.guest_name).to eq('TSTBOT')

      end

    end
  end

  context '#last_updated' do
    it 'should return the timestamp for the last value in the history' do
      guest = Guest.new(name: 'TSTBOT', attributes: {eyes: 101})
      guest.save!
      GuestHistory.new(guest_name: guest.name, timestamp: Time.parse('1-2-2013')).create!
      GuestHistory.new(guest_name: guest.name, timestamp: Time.parse('1-2-2015')).create!
      GuestHistory.new(guest_name: guest.name, timestamp: Time.parse('1-2-2045')).create!

      expect(guest.last_updated.to_i).to eq(Time.parse('1-2-2045').to_i)
    end
  end

  context '.all' do
    it 'should return all the guests stored' do
      guest1 = Guest.new(name: 'TSTBOT', attributes: {eyes: 101})
      guest1.save!

      guest2 = Guest.new(name: 'TSTBOT2', attributes: {eyes: 103})
      guest2.save!

      expect(Guest.all).to eq([guest1, guest2])
    end
  end
end
