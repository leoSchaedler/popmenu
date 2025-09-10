module Api
  # Service object responsible for importing restaurants, menus, and menu items from JSON
  class RestaurantImporter
    # Simple struct to encapsulate the result of the import process
    Result = Struct.new(:success, :logs, keyword_init: true)

    # Convenience method to call the importer without needing to instantiate
    def self.call(json:)
      new(json).call
    end

    def initialize(json)
      @json = json
      @logs = []
    end

    # Main entry point: parses JSON and imports all restaurants within a transaction,
    # any error will roll back all changes
    def call
      data = JSON.parse(@json)
      ActiveRecord::Base.transaction do
        (data["restaurants"] || []).each do |r_data|
          import_restaurant(r_data)
        end
      end
      Result.new(success: true, logs: @logs)
    rescue JSON::ParserError => e
      # Handles invalid JSON input gracefully
      Result.new(success: false, logs: [ { status: "error", message: "Invalid JSON: #{e.message}" } ])
    rescue => e
      # Captures any other unexpected errors during import
      Result.new(success: false, logs: @logs << { status: "error", message: e.message })
    end

    private

    # Imports a single restaurant and its associated menus/items,
    # and logs summary info after processing
    def import_restaurant(r_data)
      menus_count = 0
      items_count = 0

      restaurant = Restaurant.find_or_create_by!(
        name: r_data["name"],
        description: r_data["description"] || "No description provided"
      )

      (r_data["menus"] || []).each do |m_data|
        menu_result = import_menu(restaurant, m_data)
        menus_count += menu_result[:menus]
        items_count += menu_result[:items]
      end

      log(:info, restaurant.name, "Summary: #{restaurant.name} restaurant imported with #{menus_count} menus and #{items_count} items")

      { restaurant: restaurant, menus: menus_count, items: items_count }
    end

    # Imports a menu and its items for a given restaurant,
    # also deduplicates item names within the same menu
    def import_menu(restaurant, m_data)
      items_count = 0

      menu = restaurant.menus.find_or_create_by!(
        name: m_data["name"],
        description: m_data["description"] || "No description provided"
      )

      log(:info, menu.name, menu.persisted? ? "Menu imported successfully" : "Menu already exists")

      # Track seen item names to prevent duplicates
      (m_data["menu_items"] || m_data["dishes"] || []).each_with_object(Set.new) do |i_data, seen_names|
        if seen_names.include?(i_data["name"])
          log(:error, i_data["name"], "duplicate in same menu, skipped")
          next
        end
        seen_names << i_data["name"]

        item_result = import_menu_item(restaurant, menu, i_data)
        items_count += item_result[:items]
      end

      { menus: 1, items: items_count }
    end

    # Imports a single menu item, linking it to the menu and restaurant,
    # then logs conflicts and ensures items are not duplicated across restaurants
    def import_menu_item(restaurant, menu, i_data)
      item = MenuItem.find_by(name: i_data["name"])

      if item && item.restaurant_id != restaurant.id
        log(:error, i_data["name"], "conflict: item already belongs to another restaurant")
        return { items: 0 }
      end

      item ||= restaurant.menu_items.create!(
        name: i_data["name"],
        description: i_data["description"] || "No description provided",
        price: i_data["price"] || "No price provided"
      )

      if menu.menu_items.exists?(item.id)
        log(:info, item.name, "already linked to menu")
      else
        menu.menu_items << item
        log(:success, item.name, "linked to #{menu.name}")
      end

      { items: 1 }
    rescue => e
      # Captures any errors during individual item creation
      log(:error, i_data["name"], e.message)
      { items: 0 }
    end

    # Centralized logging method used throughout the import process
    def log(status, item, message)
      @logs << { item: item, status: status, message: message }
    end
  end
end
