require "rails_helper"

# Unit tests for the RestaurantImporter service
RSpec.describe Api::RestaurantImporter do
  describe ".call" do
    context "with valid JSON and multiple restaurants" do
      # Sample JSON containing two restaurants with menus and items, including conflicts/duplicates
      let(:json) do
        {
          restaurants: [
            {
              name: "Poppo's Cafe",
              description: "Cozy cafe",
              menus: [
                {
                  name: "Lunch",
                  menu_items: [
                    { name: "Burger", description: "Beef burger", price: 10.0 },
                    { name: "Salad", price: 5.0 }
                  ]
                },
                {
                  name: "Dinner",
                  menu_items: [
                    { name: "Burger", price: 10.0 }, # duplicate, should link to same MenuItem
                    { name: "Steak", price: 15.0 }
                  ]
                }
              ]
            },
            {
              name: "Casa del Poppo",
              menus: [
                {
                  name: "Lunch",
                  menu_items: [
                    { name: "Chicken Wings", price: 8.0 },
                    { name: "Burger", price: 10.0 } # conflict: already exists in Poppo's Cafe
                  ]
                }
              ]
            }
          ]
        }.to_json
      end

      subject { described_class.call(json: json) }

      it "creates restaurants, menus, and menu items correctly" do
        # Checks that the correct number of restaurants, menus, and menu items are created
        expect { subject }.to change(Restaurant, :count).by(2)
                            .and change(Menu, :count).by(3)
                            .and change(MenuItem, :count).by(4) # Burger reused
      end

      it "returns a Result struct with success true" do
        result = subject
        expect(result).to be_a(Api::RestaurantImporter::Result)
        expect(result.success).to be true
      end

      it "logs successes and errors properly" do
        result = subject

        # Ensure restaurants logs include info about successful creation
        restaurant_logs = result.logs.select { |l| l[:item].include?("Cafe") || l[:item].include?("Casa") }
        expect(restaurant_logs.map { |l| l[:status] }).to include(:info)

        # Conflicting menu item should be logged as an error
        conflict_log = result.logs.find { |l| l[:message].match?(/conflict/) }
        expect(conflict_log[:item]).to eq("Burger")
        expect(conflict_log[:status]).to eq(:error)

        # Each restaurant should have a summary log
        summary_logs = result.logs.select { |l| l[:message].match?(/Summary/) }
        expect(summary_logs.size).to eq(2)

        # Check that items linked to menus are logged as success
        success_logs = result.logs.select { |l| l[:status] == :success }.map { |l| l[:item] }
        expect(success_logs).to include("Burger", "Salad", "Steak", "Chicken Wings")
      end
    end

    context "with duplicate menu item names in the same menu" do
      let(:json) do
        {
          restaurants: [
            {
              name: "Dup Cafe",
              menus: [
                {
                  name: "Brunch",
                  menu_items: [
                    { name: "Toast" },
                    { name: "Toast" }
                  ]
                }
              ]
            }
          ]
        }.to_json
      end

      it "skips duplicates and logs an error" do
        result = described_class.call(json: json)
        error_logs = result.logs.select { |l| l[:status] == :error }
        expect(error_logs.first[:message]).to match(/duplicate/)
        expect(result.success).to be true
      end
    end

    context "with missing optional fields" do
      let(:json) do
        {
          restaurants: [
            {
              name: "NoDesc Cafe",
              menus: [
                { name: "Menu Without Desc", menu_items: [ { name: "Item Without Price" } ] }
              ]
            }
          ]
        }.to_json
      end
      subject { described_class.call(json: json) }

      it "creates records successfully" do
        # Ensures importer handles missing description/price without failure
        expect { subject }.to change(Restaurant, :count).by(1)
                            .and change(Menu, :count).by(1)
                            .and change(MenuItem, :count).by(1)

        result = subject
        expect(result.logs.any? { |l| l[:item] == "Item Without Price" }).to be true
      end
    end

    context "with invalid JSON" do
      let(:invalid_json) { "{ invalid json" }

      it "returns failure with JSON parse error" do
        result = described_class.call(json: invalid_json)
        expect(result.success).to be false
        expect(result.logs.first[:message]).to match(/Invalid JSON/)
      end
    end
  end
end
