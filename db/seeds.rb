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
  { email: "user3@example.com", password: "password789", user_name: "JSNinja" },
  { email: "user4@example.com", password: "password101", user_name: "WebDev" },
  { email: "user5@example.com", password: "password102", user_name: "CodeMaster" },
  { email: "user6@example.com", password: "password103", user_name: "TestNinja" }
].map { |attributes| User.find_or_create_by!(email: attributes[:email]) do |user|
  user.password = attributes[:password]
  user.user_name = attributes[:user_name]
end }

puts "Created #{User.count} users"

# Create Quizzes with more questions
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
        title: "Which of these are valid Ruby data types? (Select all that apply)",
        answers: [
          { body: "String", is_correct: true },
          { body: "Integer", is_correct: true },
          { body: "JavaClass", is_correct: false },
          { body: "Symbol", is_correct: true }
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
        title: "Which of these are valid Rails commands? (Select all that apply)",
        answers: [
          { body: "rails new", is_correct: true },
          { body: "rails server", is_correct: true },
          { body: "rails compile", is_correct: false },
          { body: "rails generate", is_correct: true }
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
        title: "Which of these are truthy values in JavaScript? (Select all that apply)",
        answers: [
          { body: "[]", is_correct: true },
          { body: "{}", is_correct: true },
          { body: "0", is_correct: false },
          { body: "'false'", is_correct: true }
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

# Create more attempts for various users
attempts_data = [
  { user: users[0], quiz: quizzes[0] },  # RubyLearner attempts Ruby quiz
  { user: users[0], quiz: quizzes[1] },  # RubyLearner attempts Rails quiz
  { user: users[1], quiz: quizzes[1] },  # RailsMaster attempts Rails quiz
  { user: users[1], quiz: quizzes[2] },  # RailsMaster attempts JS quiz
  { user: users[2], quiz: quizzes[2] },  # JSNinja attempts JS quiz
  { user: users[3], quiz: quizzes[0] },  # WebDev attempts Ruby quiz
  { user: users[3], quiz: quizzes[1] },  # WebDev attempts Rails quiz
  { user: users[3], quiz: quizzes[2] },  # WebDev attempts JS quiz
  { user: users[4], quiz: quizzes[1] }   # CodeMaster attempts Rails quiz
  # TestNinja has no attempts
]

attempts_data.each do |data|
  next if data[:quiz].attempted_by?(data[:user])

  attempt = data[:quiz].attempts.build(user: data[:user])
  
  data[:quiz].questions.each do |question|
    # For questions with multiple correct answers, randomly select 1-3 answers
    if question.answers.count { |a| a.is_correct? } > 1
      answers = question.answers.sample(rand(1..3))
      answers.each do |answer|
        attempt.submissions.build(
          question: question,
          answer: answer
        )
      end
    else
      # For single-answer questions, select one random answer
      answer = question.answers.sample
      attempt.submissions.build(
        question: question,
        answer: answer
      )
    end
  end

  attempt.save!
end

puts "Created #{Attempt.count} attempts with #{Submission.count} submissions"
puts "Seeding completed successfully!"