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
