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

Question.destroy_all

[
  { quiz_id: Quiz.find_by(title: "Ruby Basics").id, title: "What is Ruby?", description: "A question about the Ruby programming language." },
  { quiz_id: Quiz.find_by(title: "Rails Fundamentals").id, title: "What is Rails?", description: "A question about the Rails framework." },
  { quiz_id: Quiz.find_by(title: "JavaScript Essentials").id, title: "What is JavaScript?", description: "A question about the JavaScript programming language." }
].each do |question_attributes|
  Question.find_or_create_by!(question_attributes)
end

p "Created #{Question.count} questions"

