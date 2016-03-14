class MealsController < ApplicationController
  before_action :current_user
  before_action :current_day_for_user

  def new
    @meal = Meal.new
    @all_foods = Food.all
  end

  def create
    @meal = Meal.new(meal_params)
    if @meal.save
      if !params[:food_ids].nil?
        params[:food_ids].each do |i|
          @meal.foods << Food.find(i.to_i)
        end
      end
      if !params[:ingredient_ids].nil?
        params[:ingredient_ids].each do |i|
          @meal.ingredients << Ingredient.find(i.to_i)
        end
      end
      redirect_to meal_path(@meal)
    else
      render "new"
    end
  end

  def index
    @meals = @current_user.meals
  end

  def show
    id = params[:id]
    @meal = Meal.find(id)
  end

  def edit
    id = params[:id]
    @meal = Meal.find(id)
  end

  def update
  end

  def destroy
    @meal = Meal.find(params[:id])
    @meal.destroy
    redirect_to meals_path
  end

  def all
    render :json => Meal.order("name").as_json, :status => :ok
  end

  def last
    meal = @current_user.meals.last
    render :json => {:meal => meal.as_json, :foods => meal.foods.as_json, :ingredients => meal.ingredients.as_json}, :status => :ok
  end

  private

  def meal_params
    params.permit(:name, :user_id, :category, :food_ids, :ingredient_ids)
  end

end
