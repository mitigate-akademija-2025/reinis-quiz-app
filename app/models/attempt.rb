class Attempt < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :submissions, dependent: :destroy
  has_many :questions, through: :quiz
  has_many :answers, through: :submissions

  validates :submissions, presence: true

  accepts_nested_attributes_for :submissions

  def score
    submissions.count { |s| s.answer&.is_correct? }
  end

  def total_answers
    total_answers = 0
    quiz.questions.each do |q|
      q.answers.each do |a|
        total_answers += 1 if a.is_correct?
      end
    end
    total_answers
  end
end
