require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:other_user) { create(:user) }

  describe 'POST голосование за' do
    context 'аутентифицированный пользователь' do
      before { sign_in(other_user) }

      it 'голосует за вопрос' do
        expect do
          post :vote_up, params: { votable_type: 'question', votable_id: question.id }
        end.to change(question.votes, :count).by(1)
      end
    end

    context 'автор вопроса' do
      before { sign_in(user) }

      it 'не может голосовать за свой вопрос' do
        expect do
          post :vote_up, params: { votable_type: 'question', votable_id: question.id }
        end.not_to change(question.votes, :count)
      end

      it 'возвращает ошибку' do
        post :vote_up, params: { votable_type: 'question', votable_id: question.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST голосование против' do
    context 'аутентифицированный пользователь' do
      before { sign_in(other_user) }

      it 'голосует против вопроса' do
        expect do
          post :vote_down, params: { votable_type: 'question', votable_id: question.id }
        end.to change(question.votes, :count).by(1)
      end
    end

    context 'автор вопроса' do
      before { sign_in(user) }

      it 'не может голосовать против своего вопроса' do
        expect do
          post :vote_down, params: { votable_type: 'question', votable_id: question.id }
        end.not_to change(question.votes, :count)
      end
    end
  end

  describe 'DELETE отмена голоса' do
    before { sign_in(other_user) }

    it 'отменяет голос' do
      question.vote_up(other_user)
      expect do
        delete :cancel_vote, params: { votable_type: 'question', votable_id: question.id }
      end.to change(question.votes, :count).by(-1)
    end

    it 'возвращает обновленный рейтинг' do
      question.vote_up(other_user)
      delete :cancel_vote, params: { votable_type: 'question', votable_id: question.id }
      question.reload
      expect(question.rating).to eq 0
    end
  end
end
