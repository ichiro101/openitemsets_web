require 'spec_helper'

feature "Signing up" do
  before :each do
    @user = FactoryGirl.create(:user)
  end

  scenario "should sign me up" do
    visit "/users/new"
    fill_in "Username", :with => "Ahri"
    fill_in "Password", :with => "f0xfire"

    click_button "Sign up"
    expect(page).to have_content "Successfully"
  end

  scenario "should not sign me up with username that already exists" do
    visit "/users/new"
    fill_in "Username", :with => "Orianna"
    fill_in "Password", :with => "f0xfire"

    click_button "Sign up"
    expect(page).to have_content "taken"
  end
end

feature "Signing in" do
  before :each do
    @user = FactoryGirl.create(:user)
  end

  scenario "should sign in with correct credentials" do
    visit "/sessions/new"
    fill_in "Username", :with => "Orianna"
    fill_in "Password", :with => "Command: Shockwave"

    click_button "Sign in"
    expect(page).to have_content "Signed in as Orianna"
  end

  scenario "should not sign in with incorrect credentials" do
    visit "/sessions/new"
    fill_in "Username", :with => "Orianna"
    fill_in "Password", :with => "Command: Dissonance"

    click_button "Sign in"
    expect(page).to have_content "Invalid"
  end
end

feature "Signing out" do
  before :each do
    @user = FactoryGirl.create(:user)
  end

  scenario "should be able to sign out" do
    visit "/sessions/new"
    fill_in "Username", :with => "Orianna"
    fill_in "Password", :with => "Command: Shockwave"

    click_button "Sign in"
    expect(page).to have_content "Signed in as Orianna"

    click_link "Sign out"
    expect(page).to have_content "signed out"
  end

end
