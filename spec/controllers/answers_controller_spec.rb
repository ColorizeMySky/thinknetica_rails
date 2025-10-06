require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'аутентифицированный пользователь' do
      let(:user) { create(:user) }
      before { sign_in(user) }

      it 'создает новый ответ с валидными атрибутами' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        }.to change(question.answers, :count).by(1)
      end

      it 'присваивает ответ правильному вопросу' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:answer).question).to eq question
      end

      it 'не создает ответ с невалидными атрибутами' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        }.not_to change(question.answers, :count)
      end
    end

    context 'неаутентифицированный пользователь' do
      it 'не создает ответ' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        }.not_to change(question.answers, :count)
      end

      it 'перенаправляет на вход' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
