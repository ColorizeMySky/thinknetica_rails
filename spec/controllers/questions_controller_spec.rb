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
    before { get :new }

    it 'создает новый вопрос' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'рендерит new шаблон' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
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
end
