require 'spec_helper'
describe User do
  describe "relationships" do
    before(:each) do
      @user = User.create!(@attr)
      @followed = Factory(:user)
    end

	it "should have a relationships method" do
	  @user.should respond_to(:relationships)
	end

	it "should include the followed user in the following array" do
	  @user.follow!(@followed)
	  @user.following.should include(@followed)
	end

	it "should have a following? method" do
	  @user.should respond_to(:following?)
	end
	it "should have a follow! method" do
	  @user.should respond_to(:follow!)
	end
	it "should follow another user" do
	  @user.follow!(@followed)
	  @user.should be_following(@followed)
	end

	it "should unfollow a user" do
	  @user.follow!(@followed)
	  @user.unfollow!(@followed)
	  @user.should_not be_following(@followed)
	end

	it "should include the follower in the followers array" do
	  @user.follow!(@followed)
	  @followed.followers.should include(@user)
	end


  end
end

