FactoryBot.define do
  factory :menu_item do
    association :restaurant
    sequence(:name) { |n| "#{Faker::Food.dish} #{n}" }
    description { Faker::Food.description }
    price { format('%.2f', Faker::Commerce.price(range: 1.0..100.0)) }
  end
end




