FactoryBot.define do
  factory :robot do
    name { Faker::Name.name }
  end
end
