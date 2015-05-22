class RecipesController < ApplicationController

	def index
		# Recipe.all.sort_by{|likes| likes.thumbs_up_total - likes.thumbs_down_total }.reverse 
		@recipes = Recipe.paginate(page: params[:page], per_page: 1)
	end

	def show
		@recipe = Recipe.find(params[:id])
	end

	def new
		@recipe = Recipe.new
	end

	def create
		@recipe = Recipe.new(recipe_params)
		@recipe.chef = Chef.find(2)

		if (@recipe.save)
			flash[:success] = "Your recipe was created successfully!"
			redirect_to recipes_path
		else
			render :new
		end
	end

	def edit
		@recipe = Recipe.find(params[:id])
	end

	def update
		@recipe = Recipe.find(params[:id])

		if @recipe.update(recipe_params)
			flash[:success] = "The #{@recipe.name} recipe was updated successfully!"
			redirect_to recipe_path(@recipe.id)
		else
			render :edit
		end
	end

	def like
		@recipe = Recipe.find(params[:id])

		like = Like.create(like: params[:like], chef: @recipe.chef, recipe: @recipe)

		if like.valid?
			if params[:like] === "true"
				vote = "up-vote" 
			else
				vote = "down-vote"
			end

			flash[:success] = "Your #{vote} was successful."
		else
			flash[:danger] = "You can only vote on a recipe once."
		end

		redirect_to :back

	end

	private

		def  recipe_params
			params.require(:recipe).permit(:name, :summary, :description, :picture)
		end
end