class Submission < ApplicationRecord
  belongs_to :attempt
  belongs_to :answer
  belongs_to :question

  validate :answer_belongs_to_question
  validates :question_id, presence: true
  validates :answer_id, presence: true

  private

  def answer_belongs_to_question
    return unless answer.present? && question.present?
    
    unless answer.question_id == question_id
      errors.add(:answer, "must belong to the question being answered")
    end
  end
end
