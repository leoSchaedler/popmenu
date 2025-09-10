FactoryBot.define do
  factory :menu do
    association :restaurant
    name { "#{Faker::Restaurant.name} Menu" }
    description { Faker::Restaurant.type }

    # Optional trait to automatically create menu items
    trait :with_items do
      transient do
        items_count { 3 }
      end

      after(:create) do |menu, evaluator|
        create_list(:menu_item, evaluator.items_count, menu: menu)
      end
    end
  end
end
