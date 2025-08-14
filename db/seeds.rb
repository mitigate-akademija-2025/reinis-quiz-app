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
    owner_id: users.first.id,
    questions: [
      {
        title: "What is a Symbol in Ruby?",
        answers: [
          { body: "An immutable string-like object commonly used as a hash key", is_correct: true },
          { body: "A variable that can store multiple values", is_correct: false },
          { body: "A type of loop in Ruby", is_correct: false }
        ]
      },
      {
        title: "What does attr_accessor do?",
        answers: [
          { body: "Creates getter and setter methods for instance variables", is_correct: true },
          { body: "Creates only getter methods", is_correct: false },
          { body: "Creates only setter methods", is_correct: false }
        ]
      }
    ]
  },
  { 
    title: "Rails Fundamentals", 
    description: "Learn about Ruby on Rails", 
    owner_id: users.second.id,
    questions: [
      {
        title: "What is MVC in Rails?",
        answers: [
          { body: "Model-View-Controller architectural pattern", is_correct: true },
          { body: "Multiple Virtual Computers", is_correct: false },
          { body: "Main Virtual Config", is_correct: false }
        ]
      },
      {
        title: "What is Active Record?",
        answers: [
          { body: "Rails ORM for database interaction", is_correct: true },
          { body: "A type of database", is_correct: false },
          { body: "A recording studio", is_correct: false }
        ]
      }
    ]
  },
  { 
    title: "JavaScript Essentials", 
    description: "Master the basics of JavaScript", 
    owner_id: users.third.id,
    questions: [
      {
        title: "What is closure in JavaScript?",
        answers: [
          { body: "A function that has access to variables in its outer scope", is_correct: true },
          { body: "A way to close browser windows", is_correct: false },
          { body: "A type of loop", is_correct: false }
        ]
      },
      {
        title: "What is the difference between let and var?",
        answers: [
          { body: "let has block scope, var has function scope", is_correct: true },
          { body: "They are exactly the same", is_correct: false },
          { body: "var is newer than let", is_correct: false }
        ]
      }
    ]
  }
].map { |attributes| Quiz.find_or_create_by!(title: attributes[:title]) do |quiz|
  quiz.description = attributes[:description]
  quiz.owner_id = attributes[:owner_id]
  
  attributes[:questions].each do |q_attrs|
    question = quiz.questions.build(title: q_attrs[:title])
    q_attrs[:answers].each do |a_attrs|
      question.answers.build(a_attrs)
    end
  end
end }

puts "Created #{Quiz.count} quizzes"
puts "Created #{Question.count} questions with #{Answer.count} answers"

# Create attempts for only some users and quizzes
attempts_data = [
  { user: users.first, quiz: quizzes.first },  # First user attempts Ruby quiz
  { user: users.second, quiz: quizzes.second } # Second user attempts Rails quiz
  # Third user and JavaScript quiz remain unattempted
]

attempts_data.each do |data|
  next if data[:quiz].attempted_by?(data[:user])

  attempt = data[:quiz].attempts.build(user: data[:user])
  
  data[:quiz].questions.each do |question|
    answer = question.answers.sample # Randomly select an answer
    attempt.submissions.build(
      question: question,
      answer: answer
    )
  end

  attempt.save!
end

puts "Created #{Attempt.count} attempts with #{Submission.count} submissions"
puts "Seeding completed successfully!"