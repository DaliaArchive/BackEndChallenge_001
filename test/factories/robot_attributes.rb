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

    trait :height do
      key 'height'
      value { Faker::Measurement.height }
    end

    trait :eye_color do
      key 'eye_color'
      value { Faker::Color.color_name }
    end
  end
end
