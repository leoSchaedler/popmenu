FactoryBot.define do
  factory :menu do
    name { Faker::Restaurant.name }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    
    #Automatically create some menu_items when you create a menu
    after(:create) do |menu, evaluator|
      # You can specify how many items you want via a transient attribute
      create_list(:menu_item, evaluator.items_count, menu: menu)
    end

    # Allow overriding number of items when creating a menu
    transient do
      items_count { 0 } # default, no menu_items
    end
  end
end
