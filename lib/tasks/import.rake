# This file provides a command line entry point to call the Importer Service, allowing for the import procedure occur outside HTTP requests,
# gives a quick and easy solution to test the importer
namespace :import do
  # Task description for rake -- provides context for the user
  desc "Import restaurant data from JSON files"

  # Main rake task for importing restaurants, loads Rails environment
  task restaurant: :environment do
    # Determine which JSON files to import based on environment variables,
    # fallback to default spec/fixtures/og_restaurant_data.json (original challenge provided JSON file) if none were given
    files =
      if ENV["DIR"]
        Dir.glob("#{ENV['DIR']}/*.json")
      elsif ENV["FILES"]
        ENV["FILES"].split(",")
      else
        [ ENV["FILE"] || "spec/fixtures/og_restaurant_data.json" ]
      end

    # Tracks whether all imports succeed
    overall_success = true

    # Iterate through each file, import, and display results
    files.each do |file|
      puts "Importing #{file}..."
      json = File.read(file)
      result = Api::RestaurantImporter.call(json: json)

      # Pretty-print the success and log messages for user clarity
      puts JSON.pretty_generate(
        success: result.success,
        logs: result.logs
      )

      # Update overall_success to false if any import fails
      overall_success &&= result.success
    end

    # Exit with status code 0 if all successful, 1 otherwise
    exit(overall_success ? 0 : 1)
  end
end
