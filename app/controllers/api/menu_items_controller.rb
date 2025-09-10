module Api
  class MenuItemsController < ApplicationController
    before_action :set_restaurant, if: -> { params[:restaurant_id].present? }
    before_action :set_menu, if: -> { params[:menu_id].present? }
    before_action :set_menu_item, only: [:show, :update, :destroy]

    def index
      if @menu
        @menu_items = @menu.menu_items
      elsif @restaurant
        @menu_items = @restaurant.menu_items
      else
        @menu_items = MenuItem.all
      end
    end

    def show
      if @restaurant
        @menu_item = @restaurant.menu_items.find(params[:id])
      else
        @menu_item = MenuItem.find(params[:id])
      end
    end

    def create
      unless @restaurant
        return render json: { error: "Restaurant required" }, status: :unprocessable_entity
      end

      # Create or reuse MenuItem
      @menu_item = @restaurant.menu_items.find_or_initialize_by(name: menu_item_params[:name])
      @menu_item.assign_attributes(menu_item_params)

      if @menu_item.save
        # Also link to a menu if menu_id is provided, this CREATES a MenuItemization entry.
        # Linking Menu and MenuItem. This is the expected behaviour.
        if @menu
          @menu.menu_items << @menu_item unless @menu.menu_items.exists?(@menu_item.id)
        end
      else
        render json: @menu_item.errors, status: :unprocessable_entity
      end
    end

    def update
      @menu_item = @menu.menu_items.find(params[:id])
      if @menu_item.update(menu_item_params)
        render json: @menu_item
      else
        render json: { errors: @menu_item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @menu_item.destroy
      head :no_content
    end

    private

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def set_menu
      @menu = @restaurant.menus.find(params[:menu_id]) if @restaurant
    end

    def set_menu_item
      @menu_item = MenuItem.find(params[:id])
    end

    def menu_item_params
      params.require(:menu_item).permit(:name, :description, :price)
    end
  end
end
