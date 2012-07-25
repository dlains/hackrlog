FactoryGirl.define do
  factory :hacker do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.sequence(:name) { |n| "Tester#{n}" }
    f.password "secret"
    f.password_confirmation "secret"
    f.beta_access false
  end
end