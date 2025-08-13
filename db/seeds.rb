# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Delete existing data
puts "Cleaning up existing data..."
[Submission, Attempt, Answer, Question, Quiz, User].each(&:destroy_all)

# Create Users
users = [
  { email: "user1@example.com", password: "password123", user_name: "RubyLearner" },
  { email: "user2@example.com", password: "password456", user_name: "RailsMaster" },
  { email: "user3@example.com", password: "password789", user_name: "JSNinja" }
].map { |attributes| User.find_or_create_by!(email: attributes[:email]) do |user|
  user.password = attributes[:password]
  user.user_name = attributes[:user_name]
end }

puts "Created #{User.count} users"

# Create Quizzes
quizzes = [
  { 
    title: "Ruby Basics", 
    description: "Test your knowledge of Ruby fundamentals", 
    owner_id: users.first.id 
  },
  { 
    title: "Rails Fundamentals", 
    description: "Learn about Ruby on Rails", 
    owner_id: users.second.id 
  }
].map { |attributes| Quiz.find_or_create_by!(title: attributes[:title]) do |quiz|
  quiz.description = attributes[:description]
  quiz.owner_id = attributes[:owner_id]
end }

puts "Created #{Quiz.count} quizzes"

# Create Questions and Answers for each quiz
quizzes.each do |quiz|
  2.times do |i|
    question = quiz.questions.find_or_create_by!(title: "Question #{i + 1} for #{quiz.title}") do |q|
      q.description = "This is question #{i + 1}"
    end

    question.answers.find_or_create_by!(body: "Correct answer for question #{i + 1}") do |answer|
      answer.is_correct = true
    end

    2.times do |j|
      question.answers.find_or_create_by!(
        body: "Incorrect answer #{j + 1} for question #{i + 1}"
      ) do |answer|
        answer.is_correct = false
      end
    end
  end
end

puts "Created #{Question.count} questions with #{Answer.count} answers"

# Create Attempts and Submissions for each user and quiz
users.each do |user|
  quizzes.each do |quiz|
    next if quiz.attempted_by?(user)

    attempt = quiz.attempts.build(user: user)
    
    quiz.questions.each do |question|
      answer = question.answers.sample
      attempt.submissions.build(
        question: question,
        answer: answer
      )
    end

    attempt.save!
  end
end

puts "Created #{Attempt.count} attempts with #{Submission.count} submissions"
puts "Seeding completed successfully!"






