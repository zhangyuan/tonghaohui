# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagging do
    title "MyString"
    taggable_id 1
    indexable "MyString"
  end
end
