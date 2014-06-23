require 'spec_helper'

describe MongoStore do
  describe '.find' do
    it 'should find in the given collection, with the criteria' do
      MongoStore.create!('collection1', name: 'NAME')
      MongoStore.create!('collection1', name: 'NAME1')
      MongoStore.create!('collection2', name: 'IRRELEVANT')

      search_result = MongoStore.find('collection1', {name: 'NAME'})

      expect(search_result.size).to eq(1)
      expect(search_result[0]['name']).to eq('NAME')
    end
  end

  describe '.create!' do
    it 'should add an item in the given collection' do
      expect {
        MongoStore.create!('collection1', data: 'DATA')
      }.to change { MongoStore.find('collection1', {}).size }.by(1)
    end
  end

  describe '.update!' do
    it 'should update an existing item in the collection' do
      id = MongoStore.create!('collection1', name: 'NAME')

      MongoStore.update!('collection1', id, name: 'NAME1')

      search_result = MongoStore.find('collection1', {})
      expect(search_result.size).to eq(1)
      expect(search_result[0]['name']).to eq('NAME1')
    end
  end

  describe '.purge!' do
    it 'should clear data from all collections' do
      MongoStore.create!('collection1', name: 'NAME')
      MongoStore.create!('collection2', name: 'NAME')
      MongoStore.create!('collection3', name: 'NAME')


      MongoStore.purge!

      expect(MongoStore.find('collection1', {}).count).to be(0)
      expect(MongoStore.find('collection2', {}).count).to be(0)
      expect(MongoStore.find('collection3', {}).count).to be(0)
    end
  end
end