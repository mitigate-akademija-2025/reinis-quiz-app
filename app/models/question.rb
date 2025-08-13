class Question < ApplicationRecord
  belongs_to :quiz

  has_many :answers, dependent: :destroy
  has_many :submissions, dependent: :destroy

  validates :title, presence: true

  accepts_nested_attributes_for :answers, allow_destroy: true
end
