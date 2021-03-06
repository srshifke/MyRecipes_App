class RecipesController < ApplicationController
	before_action :set_recipe, only: [:show, :edit, :update, :like]
	before_action :require_user, except: [:show, :index, :like]
	before_action :require_user_like, only: [:like]
	before_action :require_same_user, only: [:edit, :update]
	before_action :admin_user, only: [:destroy]

	def index
		# Recipe.all.sort_by{|likes| likes.thumbs_up_total - likes.thumbs_down_total }.reverse 
		@recipes = Recipe.paginate(page: params[:page], per_page: 5)
	end

	def show
	end

	def new
		@recipe = Recipe.new
	end

	def create
		@recipe = Recipe.new(recipe_params)
		@recipe.chef = current_user

		if (@recipe.save)
			flash[:success] = "Chef, #{current_user.chefname}, your recipe was created successfully!"
			redirect_to recipe_path(@recipe)
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @recipe.update(recipe_params)
			flash[:success] = "The #{@recipe.name} recipe was updated successfully!"
			redirect_to recipe_path(@recipe)
		else
			render :edit
		end
	end

	def destroy
		Recipe.find(params[:id]).destroy
		flash[:success] = "You have successfully deleted the recipe."
		redirect_to recipes_path
	end

	def like
		like = Like.create(like: params[:like], chef: current_user, recipe: @recipe)

		if like.valid?
			if params[:like] === "true"
				vote = "up-vote" 
			else
				vote = "down-vote"
			end

			flash[:success] = "Your #{vote} was successful."
		else
			if current_user == like.recipe.chef
				flash[:danger] = like.errors.full_messages_for(:like).first[5..-1] # 'Like ' shows up at beginning, it is Error class
			else
				flash[:danger] = "You can only vote on a recipe once."
			end
		end

		redirect_to :back

	end

	private

		def  recipe_params
			params.require(:recipe).permit(:name, :summary, :description, :picture, style_ids: [], ingredient_ids: [])
		end

		def set_recipe
			@recipe = Recipe.find(params[:id])
		end

		def require_same_user
			if current_user != @recipe.chef and !current_user.admin?
				flash[:danger] = "You cannot edit a recipe you have not written."
				redirect_to recipes_path
			end
		end

		def require_user_like
    	if !logged_in?
      	flash[:danger] = "You must be logged in to perform that action."
      	redirect_to :back
    	end        
  	end

  	def admin_user
  		redirect_to recipes_path unless current_user.admin?
  	end
end