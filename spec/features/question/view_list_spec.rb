require 'rails_helper'

feature 'Пользователь просматривает список вопросов' do
  given!(:questions) { create_list(:question, 3) }

  scenario 'Пользователь видит список вопросов' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
