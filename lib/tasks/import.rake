namespace :import do
  desc "Import restaurant data from JSON files"
  task restaurant: :environment do
    files =
      if ENV["DIR"]
        Dir.glob("#{ENV['DIR']}/*.json")
      elsif ENV["FILES"]
        ENV["FILES"].split(",")
      else
        [ENV["FILE"] || "tmp/restaurant_data.json"]
      end

    overall_success = true

    files.each do |file|
      puts "Importing #{file}..."
      json = File.read(file)
      result = RestaurantImporter.call(json: json)

      puts JSON.pretty_generate(
        success: result.success,
        logs: result.logs
      )

      overall_success &&= result.success
    end

    exit(overall_success ? 0 : 1)
  end
end
