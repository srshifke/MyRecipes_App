class Like < ActiveRecord::Base
	belongs_to :chef
	belongs_to :recipe

	validates_uniqueness_of :chef, scope: :recipe
	validate :user_did_not_write_recipe

	def user_did_not_write_recipe
		if self.chef_id == self.recipe.chef.id
			errors.add(:like, "You cannot up/down-vote your own recipes.")
		end
	end
end