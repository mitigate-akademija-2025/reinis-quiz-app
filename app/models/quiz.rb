class Quiz < ApplicationRecord
  validates :title, presence: true

  has_many :questions, dependent: :destroy
  has_many :attempts, dependent: :destroy
  has_many :users, through: :attempts
  has_many :submissions, through: :attempts, dependent: :destroy
  has_many :answers, through: :questions, dependent: :destroy


  accepts_nested_attributes_for :questions, allow_destroy: true

    def attempted_by?(user)
    attempts.exists?(user: user)
  end

  def last_attempt_for(user)
    attempts.where(user: user).last
  end

    scope :search, ->(query) {
    where("title LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%") if query.present?
  }
end
