FactoryBot.define do
  factory :user do
    trait :default_role do
      user_role { :user }
    end

    trait :admin do
      user_role { :admin }
    end

    trait :basic_email do
      email { 'basic_email@test.com' }
    end

    trait :random_password do
      password { 'random_password' }
    end
  end
end
