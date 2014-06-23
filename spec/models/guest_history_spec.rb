require 'spec_helper'

describe GuestHistory do
  let (:guest) { Guest.new(name: 'guest_name', attributes: {eyes: 2}) }
  describe '.guest_created' do
    it 'should save guests created timestamp' do
      created_date = Time.parse('12 Dec 2234 13:04:12')
      change_set = build_change_set

      Timecop.freeze(created_date) do
        GuestHistory.guest_created(guest, change_set)
      end

      guest_history = GuestHistory.find('guest_name')
      expect(guest_history.count).to be(1)
      expect(guest_history.first.timestamp.to_i).to be(created_date.to_i)
      expect(guest_history.first.type).to eq('created')
      expect(guest_history.first.guest_name).to eq(guest.name)
      expect(guest_history.first.change_set).to eq(change_set)
    end
  end

  describe '.guest_updated' do
    it 'should save guests updated timestamp' do
      updated_date = Time.parse('12 Dec 2234 13:04:12')
      change_set = build_change_set

      Timecop.freeze(updated_date) do
        GuestHistory.guest_updated(guest, change_set)
      end

      guest_history = GuestHistory.find('guest_name')
      expect(guest_history.count).to be(1)
      expect(guest_history.first.timestamp.to_i).to be(updated_date.to_i)
      expect(guest_history.first.type).to eq('updated')
      expect(guest_history.first.guest_name).to eq(guest.name)
      expect(guest_history.first.change_set).to eq(change_set)
    end
  end

  describe '#initialize' do
    it 'should initialize with params' do
      guest_history = GuestHistory.new(timestamp: 'timestamp', type: 'created', guest_name: 'name', change_set: [{attribute: 'attr', from: 1, to: 2}])

      expect(guest_history.timestamp).to eq('timestamp')
      expect(guest_history.type).to eq('created')
      expect(guest_history.guest_name).to eq('name')
      expect(guest_history.change_set).to eq(ChangeSet.new([{attribute: 'attr', from: 1, to: 2}]))
    end

    it 'should initialize with params with string keys as well' do
      guest_history = GuestHistory.new('timestamp' => 'timestamp', 'type' => 'created', 'guest_name' => 'name')

      expect(guest_history.timestamp).to eq('timestamp')
      expect(guest_history.type).to eq('created')
      expect(guest_history.guest_name).to eq('name')
    end
  end

  describe '.find' do
    it 'should find the guest_history by guest_name' do
      r2d2_history = GuestHistory.new(guest_name: 'r2d2', type: 'created')
      r2d2_history.create!
      c3pu_history = GuestHistory.new(guest_name: 'c3pu', type: 'created')
      c3pu_history.create!

      expect(GuestHistory.find('r2d2')).to eq([r2d2_history])
    end
  end

  describe '#create!' do
    it 'should create a new guest_history' do
      history = GuestHistory.new(guest_name: 'name', type: 'type', timestamp: Time.parse('12 Dec 2234 13:04:12'))
      history.change_set = build_change_set

      expect {
        history.create!
      }.to change{GuestHistory.find('name').size}.by(1)


      expect(GuestHistory.find('name').first).to eq(history)
      expect(GuestHistory.find('name').first.change_set).to eq(build_change_set)
    end
  end

  describe 'equality' do
    it 'should be equal if guest_name, type and timestamp matches' do
      guest_history = GuestHistory.new(guest_name: 'name', type: 'type', timestamp: DateTime.parse('12 Dec 2234 13:04:12'))

      expect(guest_history).to eq(GuestHistory.new(guest_name: 'name', type: 'type', timestamp: DateTime.parse('12 Dec 2234 13:04:12')))
    end

    it 'should not be equal if guest_name or type or timestamp or class dosent matches' do
      guest_history = GuestHistory.new(guest_name: 'name', type: 'type', timestamp: DateTime.parse('12 Dec 2234 13:04:12'))

      expect(guest_history).not_to eq(GuestHistory.new(guest_name: 'name1', type: 'type', timestamp: DateTime.parse('12 Dec 2234 13:04:12')))
      expect(guest_history).not_to eq(GuestHistory.new(guest_name: 'name', type: 'type2', timestamp: DateTime.parse('12 Dec 2234 13:04:12')))
      expect(guest_history).not_to eq(GuestHistory.new(guest_name: 'name', type: 'type', timestamp: DateTime.parse('13 Dec 2234 13:04:12')))
      expect(guest_history).not_to eq('a string')
    end
  end

  def build_change_set
    change_set = ChangeSet.new
    change_set << Change.new(attribute: 'a', from: '0', to: '2')
    change_set
  end
end