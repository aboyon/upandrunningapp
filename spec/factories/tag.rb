FactoryBot.define do
  factory :tag, :class => Tag do
    sequence(:name) { |n| "Tag_#{n}" }
    trait :invalid do
      name { '' }
    end
  end
end
