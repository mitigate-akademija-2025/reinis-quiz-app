class Quiz < ApplicationRecord
  validates :title, presence: true

  has_many :questions, dependent: :destroy
  has_many :attempts, dependent: :destroy
  has_many :users, through: :attempts


  accepts_nested_attributes_for :questions, allow_destroy: true

    def attempted_by?(user)
    attempts.exists?(user: user)
  end

  def last_attempt_for(user)
    attempts.where(user: user).last
  end
end
