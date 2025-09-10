module Api
  class ImportsController < ApplicationController
    
    def new
      # Just renders the view with the file upload form for JSON Files
    end

    # Handles the actual import process
    def create
      file = params[:file]

      # Return error if no file was uploaded
      unless file
        return render json: { success: false, logs: ["No file provided"] }, status: :unprocessable_entity
      end

      # Only allow JSON files
      unless file.content_type == "application/json" || File.extname(file.original_filename) == ".json"
        return render json: { success: false, logs: ["Invalid file type, only JSON allowed"] }, status: :unprocessable_entity
      end
      
      # Read the uploaded file's contents
      if file.respond_to?(:path)
        json = File.read(file.path)
      else
        json = File.read(file.to_s)
      end

      # Call the service object to process the JSON import
      result = Api::RestaurantImporter.call(json: json)

      # Respond with JSON for API requests, or render the form with results for browser
      if request.format.json?
        render json: { success: result.success, logs: result.logs }
      else
        @result = result
        render :new
      end
    end
  end
end
