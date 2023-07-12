FactoryBot.define do
  factory :comment do
    association :user, factory: :user
    association :bargain, factory: :bargain

    trait :simple_body do
      body { 'Some random text' }
    end
  end
end
