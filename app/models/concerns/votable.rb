module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    return false if user == self.user

    votes.create(user: user, value: 1)
  end

  def vote_down(user)
    return false if user == self.user

    votes.create(user: user, value: -1)
  end

  def cancel_vote(user)
    votes.where(user: user).destroy_all
  end

  def rating
    votes.sum(:value)
  end

  def voted_by?(user)
    votes.exists?(user: user)
  end
end
