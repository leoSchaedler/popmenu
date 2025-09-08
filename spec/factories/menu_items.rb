FactoryBot.define do
  factory :menu_item do
    name { Faker::Food.dish }
    description { Faker::Lorem.sentence }
    price { format('%.2f', Faker::Commerce.price(range: 1.0..100.0)) }

    # Association with menu for nested creation
    association :menu
  end
end
