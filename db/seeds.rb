# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


User.destroy_all


[
  { email: "user1@example.com", password: "password123", user_name: "RubyLearner" },
  { email: "user2@example.com", password: "password456", user_name: "RailsMaster" },
  { email: "user3@example.com", password: "password789", user_name: "JSNinja" }
].each do |user_attributes|
  User.create!(user_attributes)
end

p "Created #{User.count} users"

Quiz.destroy_all

[
  { title: "Ruby Basics", description: "A quiz about the basics of Ruby programming.", owner_id: User.find_by(user_name: "RubyLearner").id },
  { title: "Rails Fundamentals", description: "Test your knowledge of Ruby on Rails.", owner_id: User.find_by(user_name: "RailsMaster").id },
  { title: "JavaScript Essentials", description: "A quiz covering essential JavaScript concepts.", owner_id: User.find_by(user_name: "JSNinja").id }
].each do |quiz_attributes|
  Quiz.find_or_create_by!(quiz_attributes)
end

p "Created #{Quiz.count} quizzes"

Question.destroy_all

[
  { quiz_id: Quiz.find_by(title: "Ruby Basics").id, title: "What is Ruby?", description: "A question about the Ruby programming language." },
  { quiz_id: Quiz.find_by(title: "Rails Fundamentals").id, title: "What is Rails?", description: "A question about the Rails framework." },
  { quiz_id: Quiz.find_by(title: "JavaScript Essentials").id, title: "What is JavaScript?", description: "A question about the JavaScript programming language." }
].each do |question_attributes|
  Question.find_or_create_by!(question_attributes)
end

p "Created #{Question.count} questions"

Answer.destroy_all

[
  { question_id: Question.find_by(title: "What is Ruby?").id, body: "Ruby is a dynamic, open-source programming language.", is_correct: true },
  { question_id: Question.find_by(title: "What is Rails?").id, body: "Rails is a web application framework written in Ruby.", is_correct: true },
  { question_id: Question.find_by(title: "What is JavaScript?").id, body: "JavaScript is a programming language primarily used for web development.", is_correct: true }
].each do |answer_attributes|
  Answer.find_or_create_by!(answer_attributes)
end

p "Created #{Answer.count} answers"







