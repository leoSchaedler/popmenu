module Api
  class MenusController < ApplicationController
    before_action :set_restaurant
    before_action :set_menu, only: [:show, :update, :destroy]

    def index
      @menus = @restaurant.menus
    end


    def show
      # @menu is already set by before_action
    end

    def create
      @menu = @restaurant.menus.build(menu_params)

      if @menu.save
        render json: @menu, status: :created
      else
        render json: @menu.errors, status: :unprocessable_entity
      end
    end

    def update
      if @menu.update(menu_params)
        render json: @menu
      else
        render json: @menu.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @menu.destroy
      head :no_content
    end

    private

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def set_menu
      @menu = @restaurant.menus.find(params[:id])
    end

    def menu_params
      params.require(:menu).permit(:name, :description)
    end
  end
end
