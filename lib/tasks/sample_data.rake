namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    99.times do |n|
      username = "example_user#{n+1}"
      password  = "password"
      User.create!(username: username,
                   password: password,
                   password_confirmation: password)
    end
  end
end