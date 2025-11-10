require 'rails_helper'

RSpec.describe Votable do
  with_model :WithVotable do
    table do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.timestamps
    end

    model do
      include Votable
      belongs_to :user
    end
  end

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:votable) { WithVotable.create!(title: 'Test', body: 'Test body', user: user) }

  describe 'голосование за' do
    it 'создает положительный голос от пользователя' do
      expect { votable.vote_up(other_user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.last.value).to eq 1
    end

    it 'не позволяет автору голосовать за свой ресурс' do
      expect { votable.vote_up(user) }.not_to change(votable.votes, :count)
    end
  end

  describe 'голосование против' do
    it 'создает отрицательный голос от пользователя' do
      expect { votable.vote_down(other_user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.last.value).to eq(-1)
    end
  end

  describe 'отмена голоса' do
    it 'удаляет существующий голос' do
      votable.vote_up(other_user)
      expect { votable.cancel_vote(other_user) }.to change(votable.votes, :count).by(-1)
    end
  end

  describe 'рейтинг' do
    it 'вычисляет общий рейтинг' do
      votable.vote_up(other_user)
      votable.vote_up(create(:user))
      votable.vote_down(create(:user))
      expect(votable.rating).to eq 1
    end
  end

  describe 'проверка голосования пользователя' do
    it 'возвращает true если пользователь голосовал' do
      votable.vote_up(other_user)
      expect(votable.voted_by?(other_user)).to be true
    end
  end
end
