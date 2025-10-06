require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'находит нужный вопрос' do
      expect(assigns(:question)).to eq question
    end

    it 'рендерит show шаблон' do
      expect(response).to render_template :show
    end

    it 'находит ответы для вопроса' do
      answers = create_list(:answer, 2, question: question)
      expect(assigns(:question).answers).to match_array(answers)
    end
  end

  describe 'GET #new' do
    context 'аутентифицированный пользователь' do
      let(:user) { create(:user) }
      before { sign_in(user) }
      before { get :new }

      it 'создает новый вопрос' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'рендерит new шаблон' do
        expect(response).to render_template :new
      end
    end

    context 'неаутентифицированный пользователь' do
      it 'перенаправляет на вход' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'аутентифицированный пользователь' do
      let(:user) { create(:user) }
      before { sign_in(user) }

      it 'создает новый вопрос с валидными атрибутами' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(Question, :count).by(1)
      end

      it 'не создает вопрос с невалидными атрибутами' do
        expect {
          post :create, params: { question: attributes_for(:question, :invalid) }
        }.not_to change(Question, :count)
      end
    end

    context 'неаутентифицированный пользователь' do
      it 'не создает вопрос' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.not_to change(Question, :count)
      end

      it 'перенаправляет на вход' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
