class Attempt < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :submissions, dependent: :destroy
  has_many :questions, through: :quiz
  
  validates :submissions, presence: true
  
  accepts_nested_attributes_for :submissions

  def score
    submissions.count { |s| s.answer&.is_correct? }
  end
end