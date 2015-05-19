require 'test_helper'

class ChefTest < ActiveSupport::TestCase

	def setup
		@chef = Chef.new(chefname: "John", email: "john@example.com")
	end

	test "chef should be valid"	do
		assert @chef.valid?
	end

	test "chefname should be presetn" do
		@chef.chefname = ""
		assert_not @chef.valid?
	end

	test "chefname should not be too long" do
		@chef.chefname = "a" * 41
		assert_not @chef.valid?
	end

	test "chefname should not be too short" do
		@chef.chefname = "a" * 2
		assert_not @chef.valid?
	end

	test "email should be present" do
		@chef.email = ""
		assert_not @chef.valid?
	end

	test "email length should not be too long" do
		@chef.email = "a" * 101 + "@example.com"
		assert_not @chef.valid?
	end

	# test to make sure email unique, and 
	# does uniqueness does not care about
	# case-sensitivity
	test "email should be unique" do
		duplicate_chef = @chef.dup
		duplicate_chef.email = @chef.email.upcase
		@chef.save
		assert_not duplicate_chef.valid?
	end

	test "email validation should accept valid addresses" do
		valid_addresses = %w[user@eee.com R_TDD-DS@eee.hello.org user@example.com first.last@eee.au first+last@asdf.cm]
		valid_addresses.each do |address|
			@chef.email = address
			assert @chef.valid?, "#{address.inspect} should be valid"
		end
	end

	test "email validation should reject invalid addresses" do
		invalid_addresses = %w[user@example,com user_at_eee.org name@example eee@i_am_.com foo@eee+aar.com]
		invalid_addresses.each do |address|
			@chef.email = address
			assert_not @chef.valid?, "#{address.inspect} should be invalid"
		end
	end

end