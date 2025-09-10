module Api
  class RestaurantsController < ApplicationController
    before_action :set_restaurant, only: [ :show, :update, :destroy ]

    def index
      @restaurants = Restaurant.all
    end

    def show
      # @restaurant is already set by before_action
    end

    def create
      @restaurant = Restaurant.new(restaurant_params)
      if @restaurant.save
        render json: @restaurant, status: :created
      else
        render json: @restaurant.errors, status: :unprocessable_entity
      end
    end

    def update
      if @restaurant.update(restaurant_params)
        render json: @restaurant
      else
        render json: @restaurant.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @restaurant.destroy
      head :no_content
    end

    private

    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :description)
    end
  end
end
