class EntriesController < ApplicationController
  before_action :current_user
  before_action :current_day_for_user

  def create
    date = Day.find(params[:day_id]).day.to_s.slice(0,10)
    entry_time = params[:time]
    entry_datetime = DateTime.parse(date + " " + entry_time)
    @entry = Entry.new(entry_params)
    @entry.time = entry_datetime
    if @entry.save
      add_or_update_meals_in_entry
      add_or_update_foods_in_entry
      add_or_update_ingredients_in_entry
      redirect_to day_path(Day.find(params[:day_id]))
    else
      flash[:error] = "We couldn't save your entry! Please try again."
    end
  end

  def edit
    @entry = Entry.find(params[:id])
    @day_id = @entry.day_id
    @user_id = @current_user.id
    @time = @entry.military_conversion(params[:id])
    @all_meals = @current_user.meals
    @all_foods = Food.all
    @all_ingredients = Ingredient.all
    @meals = @entry.meals
    @foods = @entry.foods
    @ingredients = @entry.ingredients
  end

  def update
    @entry = Entry.find(params[:id])
    date = Day.find(params[:day_id]).day.to_s.slice(0,10)
    entry_time = params[:time]
    entry_datetime = DateTime.parse(date + " " + entry_time)
    @entry.time = entry_datetime
    @entry.category = params[:category]
    @entry.notes = params[:notes]
    if @entry.save
      add_or_update_meals_in_entry
      add_or_update_foods_in_entry
      add_or_update_ingredients_in_entry
    end
    render nothing: true
  end

  def last
    entry = @current_user.entries.last
    entry_time = entry.time.strftime("%l:%M %p")
    render :json => {:entry => entry.as_json, :entry_time => entry_time.as_json, :caps => entry.print_capitals(entry.id).as_json, :italics => entry.print_italics(entry.id).as_json}, :status => :ok
  end

  def destroy
    @entry = Entry.find(params[:id])
    day_id = @entry.day_id
    @entry.destroy
    redirect_to day_path(day_id)
  end

  private

  def entry_params
    params.permit(:time, :category, :notes, :user_id, :day_id)
  end

  def add_or_update_meals_in_entry
    if !params[:meal_ids].nil? && !params[:meal_ids].empty?
      @entry.meals = []
      params[:meal_ids].each do |i|
        @entry.meals << Meal.find(i.to_i)
      end
    end
  end

  def add_or_update_foods_in_entry
    if !params[:food_ids].nil? && !params[:food_ids].empty?
      @entry.foods = []
      params[:food_ids].each do |i|
        @entry.foods << Food.find(i.to_i)
      end
    end
  end

  def add_or_update_ingredients_in_entry
    if !params[:ingredient_ids].nil? && !params[:ingredient_ids].empty?
      @entry.ingredients = []
      params[:ingredient_ids].each do |i|
        @entry.ingredients << Ingredient.find(i.to_i)
      end
    end
  end

end
