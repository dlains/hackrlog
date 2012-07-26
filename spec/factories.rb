FactoryGirl.define do
  factory :hacker do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.sequence(:name) { |n| "Tester#{n}" }
    f.password "secret"
    f.password_confirmation "secret"
    f.beta_access false
  end
  
  factory :entry do |f|
    hacker
    f.sequence(:content) { |n| "Entry Content Number #{n}." }
  end
  
  factory :tag do |f|
    f.sequence(:name) { |n| "tag#{n}" }
  end
end