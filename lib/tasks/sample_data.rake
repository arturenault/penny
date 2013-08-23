namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(username: "admin_user",
                         password: "foobar",
                         password_confirmation: "foobar",
                         admin: true)
    99.times do |n|
      username = "example_user#{n+1}"
      password  = "password"
      User.create!(username: username,
                   password: password,
                   password_confirmation: password)
    end
  end
end