# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_set do
    title "Generic Ahri Build"
    champion "Ahri"
    role "Mid"
    visible_to_public true
    association :user
  end
end
