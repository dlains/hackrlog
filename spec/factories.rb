FactoryGirl.define do

  factory :entry do |f|
    hacker
    f.sequence(:content) { |n| "Entry Content Number #{n}." }
  end

  factory :hacker do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.sequence(:name) { |n| "Tester#{n}" }
    f.password "secret"
    f.password_confirmation "secret"
    f.beta_access false
    
    factory :hacker_with_entries do
      ignore do
        entries_count 5
      end
      
      after(:create) do |hacker,evaluator|
        FactoryGirl.create_list(:entry, evaluator.entries_count, hacker: hacker)
      end
    end
  end
  
  factory :tag do |f|
    f.sequence(:name) { |n| "tag#{n}" }
  end
end