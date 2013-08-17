require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the h1 'Penny'" do
      visit root_path
      expect(page).to have_content('Penny')
    end

    it "should have the base title" do
      visit root_path
      expect(page).to have_title("Penny")
    end

    it "should not have a custom page title" do
      visit root_path
      expect(page).not_to have_title('| Home')
    end
  end

  describe "Help page" do

    it "should have the h1 'Help'" do
      visit help_path
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      visit help_path
      expect(page).to have_title("Penny | Help")
    end
  end

  describe "About page" do

    it "should have the h1 'About'" do
      visit about_path
      expect(page).to have_content('About')
    end

    it "should have the title 'About Us'" do
      visit about_path
      expect(page).to have_title("Penny | About")
    end
  end

  describe "Contact page" do

    it "should have the content 'Contact'" do
      visit contact_path
      expect(page).to have_content('Contact')
    end

    it "should have the title 'Contact'" do
      visit contact_path
      expect(page).to have_title("Penny | Contact")
    end
  end
end