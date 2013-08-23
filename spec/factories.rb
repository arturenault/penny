FactoryGirl.define do
  sequence(:username) { |n| "Person#{n}" }

  factory :user do
    username "example_user"
    password "foobar"
    password_confirmation "foobar"
    factory :admin do
      admin true
      username "admin_user"
    end
  end

  factory :post do
    content "Lorem ipsum"
    user
  end
end