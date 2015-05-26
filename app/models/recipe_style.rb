class RecipeStyle < ActiveRecord::Base
	belongs_to :recipe, touch: true
	belongs_to :style
end