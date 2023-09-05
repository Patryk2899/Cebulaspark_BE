# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

LINK = 'https://www.google.com'.freeze
DESCRIPTION = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'.freeze

Category.create!([{ name: 'home' },
                  { name: 'electronics' },
                  { name: 'fashion' },
                  { name: 'health' },
                  { name: 'groceries' },
                  { name: 'culture' },
                  { name: 'sport' },
                  { name: 'travel' },
                  { name: 'kids' },
                  { name: 'pets' }])

if Rails.env.development?
  puts "#{Rails.root}/db/seed_images/*.jpg"
  image_files = Dir.glob(File.join("#{Rails.root}/db/seed_images", '*.jpeg'))

  user = User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  user.user_role = 1
  user.save

  20.times do |index|
    User.create!(email: Faker::Internet.email, password: "password#{index}",
                 password_confirmation: "password#{index}")
  end
  all_categories = Category.all
  50.times do |index|
    categories = []
    3.times do
      categories.append(all_categories.sample)
    end
    categories = categories.uniq
    random_user = rand(2..21)
    bargain = Bargain.create!(title: "Title #{index}",
                              description: Faker::Lorem.sentence,
                              link: LINK,
                              ends_at: DateTime.tomorrow,
                              user_id: random_user,
                              categories:)
    image_file = image_files.sample
    puts image_file.inspect
    puts image_files.inspect
    next unless image_file

    ImageProcessing::MiniMagick.source(image_file)
                               .resize_to_limit(500, 500)
                               .call(destination: image_file)
    bargain.main_image.attach(io: File.open(image_file), filename: "main_image#{index}.jpg")
    puts bargain.main_image.inspect
  end
end
