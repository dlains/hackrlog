FactoryGirl.define do
  factory :hacker do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.sequence(:name) { |n| "Tester#{n}" }
    f.password "secret"
    f.password_confirmation "secret"
  end
end