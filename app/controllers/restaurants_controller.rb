class RestaurantsController < ApplicationController
  def index
    @restaurants = policy_scope(current_user.restaurants)
    # @photo.restaurant_id = @restaurant.id
  end

  def show
    @restaurant = Restaurant.geocoded.find(params[:id])
    @markers =
      [{
        lat: @restaurant.latitude,
        lng: @restaurant.longitude,
        image_url: helpers.asset_url("chef-icon-color.png"),
      }]
    authorize @restaurant
  end

  def new
    @restaurant = Restaurant.new
    authorize @restaurant
  end

  def create
    @user = current_user
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = @user
    authorize @restaurant
    if @restaurant.save
      redirect_to restaurants_path
    else
      render "new"
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    @photo = Photo.new
    authorize @restaurant
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
    @restaurant.update(restaurant_params)
    
    if params['redirection'] == 'true'
      redirect_to restaurants_path
    end
    # Will raise ActiveModel::ForbiddenAttributesError
  end

  def update_activation
    # raise
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
    if @restaurant.activated
      @restaurant.update(activated: false)
    else
      @restaurant.update(activated: true)
    end
    redirect_to edit_restaurant_path(@restaurant)
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :contact_email, :activated, :domain_name, :description, :phone_number, :photo)
  end
end
