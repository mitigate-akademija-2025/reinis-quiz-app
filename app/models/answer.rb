class Answer < ApplicationRecord
  belongs_to :question

  has_many :submissions

  validates :body, presence: true
  validates :is_correct, inclusion: { in: [true, false] }
end
