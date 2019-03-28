FactoryBot.define do
  factory :resource, :class => Resource do
    sequence(:name) { |n| "Resource_Name_#{n}" }
    trait :invalid do
      name { '' }
    end
  end
end
