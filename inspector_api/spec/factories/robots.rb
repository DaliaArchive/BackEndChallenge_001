FactoryGirl.define do
  factory :robot do
    name { Faker::Lorem.word }
    properties do
      {
        size: '100kg',
        weight: '10kg',
        status: 'good condition',
        color: 'white',
        age: '123years'
      }
    end
  end
end