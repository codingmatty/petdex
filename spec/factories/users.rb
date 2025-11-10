FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :with_reset_token do
      reset_password_token { Devise.friendly_token }
      reset_password_sent_at { Time.current }
    end

    trait :remembered do
      remember_created_at { Time.current }
    end
  end
end
