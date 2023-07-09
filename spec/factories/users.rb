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

    trait :reset_password_sent_at_minus_four_days do
      reset_password_sent_at { Time.now - 4.days }
    end

    trait :reset_password_sent_at do
      reset_password_sent_at { Time.now }
    end

    trait :reset_password_token1 do
      reset_password_token { 'random_hash1' }
    end

    trait :reset_password_token2 do
      reset_password_token { 'random_hash2' }
    end

    trait :test_email1 do
      email { 'test1@test.pl' }
    end

    trait :test_email2 do
      email { 'test2@test.pl' }
    end
  end
end
