require 'spec_helper'

describe User do

  before do
    @user = User.new(username: "Example_User", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:posts) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

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
      user_with_same_username.username = @user.username.upcase
      user_with_same_username.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(username: "ExampleUser",
                     password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(username: @user.username) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "post associations" do

    before { @user.save }
    let!(:older_post) do
      FactoryGirl.create(:post, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_post) do
      FactoryGirl.create(:post, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right posts in the right order" do
      expect(@user.posts.to_a).to eq [newer_post, older_post]
    end

    it "should destroy associated posts" do
      posts = @user.posts.to_a
      @user.destroy
      expect(posts).not_to be_empty
      posts.each do |post|
        expect(Post.where(id: post.id)).to be_empty
      end
    end
    
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:post, user: FactoryGirl.create(:user, username: FactoryGirl.generate(:username)))
      end

      its(:feed) { should include(newer_post) }
      its(:feed) { should include(older_post) }
      its(:feed) { should_not include(unfollowed_post) }
    end
  end
end