class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, as: :linkable, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  include Votable

  def mark_as_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update(best: true)
      question.reward&.update(user: user) if question.reward
    end
  end
end
