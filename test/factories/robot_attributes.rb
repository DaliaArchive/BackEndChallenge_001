FactoryBot.define do
  factory :robot_attribute do
    robot

    trait :color do
      key 'color'
      value { Faker::Color.color_name }
    end

    trait :weight do
      key 'weight'
      value { Faker::Measurement.weight }
    end
  end
end
