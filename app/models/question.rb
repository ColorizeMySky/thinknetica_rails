class Question < ApplicationRecord
  has_one :reward, dependent: :destroy

  has_many :answers, dependent: :destroy
  has_many_attached :files
  has_many :links, as: :linkable, dependent: :destroy

  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, presence: true
  validates :body, presence: true
end
