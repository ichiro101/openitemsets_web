require 'spec_helper'

describe User do
  before do
    @user = User.new
    @user.username = "Ahri"
    @user.password = "f0xfire"
    @user.email = "Ahri@example.com"

    @save_result = @user.save

    @user2 = FactoryGirl.create(:user, :username => "longPassworduser", 
                                :password => "pDAxf6uut5mTSkO5ROR5Z7FELA9bLj6l6E")
  end

  it "should be able to create the user record" do
    @save_result.should_not be_false
  end

  it "should be able to authenticate the user with correct credentials" do
    user_record = User.authenticate("Ahri", "f0xfire")
    user_record.username.should == "Ahri"
  end

  it "should be able to authenticate with email as well" do
    user_record = User.authenticate("Ahri@example.com", "f0xfire")
    user_record.username.should == "Ahri"
  end

  it "should be able to authenticate long password user with correct credentials" do
    user_record = User.authenticate("longPassworduser", "pDAxf6uut5mTSkO5ROR5Z7FELA9bLj6l6E")
    user_record.username.should == "longPassworduser"
  end

  it "should not be able to authenticate the user with incorrect credentials" do
    user_record = User.authenticate("Ahri", "sprit rush")
    user_record.should be_blank
  end

  it "should not be able to authenticate non-existing users" do
    user_record = User.authenticate("Teemo", "f0xfire")
    user_record.should be_blank
  end

  it "should set email confirmation token" do
    @user.email_confirmation_token.should_not be_blank
  end

end
