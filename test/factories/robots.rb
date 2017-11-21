FactoryBot.define do
  factory :robot do
    name { Faker::Name.name }

    factory :robot_with_four_attributes do
      after(:create) do |robot|
        create(:robot_attribute, :color, robot: robot)
        create(:robot_attribute, :weight, robot: robot)
        create(:robot_attribute, :height, robot: robot)
        create(:robot_attribute, :eye_color, robot: robot)
      end
    end

    factory :robot_with_two_attributes do
      after(:create) do |robot|
        create(:robot_attribute, :color, robot: robot)
        create(:robot_attribute, :weight, robot: robot)
      end
    end
  end
end
