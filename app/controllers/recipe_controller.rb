class RecipeController < ApplicationController
  before_action :authorize
  
  def index
    @categories = Category.all
    if params[:word].present?
      @recipies = Recipe.where("name like ?", "%#{params[:word]}%").order("id desc")
    else
      @recipies = Recipe.all.order("id desc")
    end
    if params[:category].present?
      @recipies = @recipies.where("category_id = ?", params[:category])
    end
  end
  def recipe_journey
    @recipe = Recipe.find(params[:id])
  end
end
