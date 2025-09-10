FactoryBot.define do
  factory :menu_itemization do
    association :menu
    association :menu_item
  end
end
