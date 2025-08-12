# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


Quiz.destroy_all

[
  { title: "Ruby Basics", description: "A quiz about the basics of Ruby programming." },
  { title: "Rails Fundamentals", description: "Test your knowledge of Ruby on Rails." },
  { title: "JavaScript Essentials", description: "A quiz covering essential JavaScript concepts." }
].each do |quiz_attributes|
  Quiz.find_or_create_by!(quiz_attributes)
end

p "Created #{Quiz.count} tasks"





