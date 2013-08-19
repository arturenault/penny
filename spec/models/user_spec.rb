require 'spec_helper'

describe User do

  before { @user = User.new(username: "ExampleUser")}

  subject { @user }

  it { should respond_to(:username) }

  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end

  describe "when username is too long" do
    before { @user.username = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when username uses illegal characters" do
    it "should be invalid" do
      names = %w[artur.renault ?????? árb !!!]
      names.each do |invalid_name|
        @user.username = invalid_name
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when username is valid" do
    it "should be valid" do
      names = %w[artur_renault artur artur2 Artur Artur_2 12345]
      names.each do |valid_name|
        @user.username = valid_name
        expect(@user).to be_valid
      end
    end
  end

  describe "when username is already taken" do
    before do
      user_with_same_username = @user.dup
      user_with_same_username.username = @user.email.upcase
      user_with_same_username.save
    end

    it { should_not be_valid }
  end
end