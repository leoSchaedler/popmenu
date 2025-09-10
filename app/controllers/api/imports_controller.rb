module Api
  class ImportsController < ApplicationController
    # skip_before_action :verify_authenticity_token, only: [:create] # for API-style posting

    def new
      # just renders the view with the file upload form
    end

    def create
      file = params[:file]

      unless file
        return render json: { success: false, logs: ["No file provided"] }, status: :unprocessable_entity
      end

      if file.respond_to?(:path)
        json = File.read(file.path)
      else
        json = File.read(file.to_s)
      end
      
      result = RestaurantImporter.call(json: json)

      if request.format.json?
        render json: { success: result.success, logs: result.logs }
      else
        @result = result
        render :new
      end
    end
  end
end
