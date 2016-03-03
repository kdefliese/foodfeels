class DaysController < ApplicationController
  before_action :current_user
  before_action :current_day_for_user

  def show
    @day = Day.find(params[:id])
    @day_id = @day.id
    @user_id = @current_user.id
    @entries = @day.entries.order("time")
    @entry = Entry.new
    @all_meals = @current_user.meals.order("name")
    @all_foods = Food.all
    @all_ingredients = Ingredient.all
  end

  private

  def day_params
    params.permit(:day, :user_id)
  end


end
