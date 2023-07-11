FactoryBot.define do
  factory :category do
    trait :electronics do
      name { 'electronics' }
    end

    trait :home do
      name { 'home' }
    end

    trait :health do
      name { 'health' }
    end
  end
end
