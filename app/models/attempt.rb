class Attempt < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :submissions, dependent: :destroy
  has_many :questions, through: :quiz
  has_many :answers, through: :submissions

  validates :submissions, presence: true

  accepts_nested_attributes_for :submissions

  def score
    total_score = 0

    quiz.questions.each do |question|
      question_score = 0
      submissions = self.submissions.select { |s| s.question_id == question.id }
      question_score += submissions.count { |s| s.answer&.is_correct? }
      question_score -= submissions.count { |s| !s.answer&.is_correct? }
      question_score = [ question_score, 0 ].max
      correct_answers_count = question.answers.count { |a| a.is_correct? }
      total_score += (question_score.to_f / correct_answers_count) if correct_answers_count > 0
    end
    total_score.round(2)
  end
end
