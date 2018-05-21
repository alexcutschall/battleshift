FactoryBot.define do
  factory :user, class: User do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "foo#{n}@foo.com" }
    password "password"
    password_confirmation "password"
    sequence(:api_key) { |n| "API_KEY_#{n}" }
  end

  factory :activated_user, class: User do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "foo#{n}@foo.com" }
    password "password"
    password_confirmation "password"
    activated true
    sequence(:api_key) { |n| "API_KEY_#{n}" }
  end
end
