FactoryBot.define do
  factory :bargain do
    association :user, factory: :user
    association :category_ids, factory: :category

    trait :short_description do
      description { 'short description' }
    end

    trait :active do
      active { true }
    end

    trait :obsolete do
      ends_at { DateTime.now - 2.days }
    end

    trait :not_obsolete do
      ends_at { DateTime.now + 2.days }
    end

    trait :invalid_link do
      link { 'no such link' }
    end

    trait :valid_link do
      link { 'https://www.google.com' }
    end

    trait :title do
      title { 'Look at this!' }
    end
  end
end
