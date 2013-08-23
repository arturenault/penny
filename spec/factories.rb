FactoryGirl.define do
  sequence(:username) { |n| "Person#{n}" }
  
  factory :user do
    username "example_user"
    password "foobar"
    password_confirmation "foobar"
  end
end