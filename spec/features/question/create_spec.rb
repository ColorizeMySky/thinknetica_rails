require 'rails_helper'

feature 'Пользователь создает вопрос' do
  given(:user) { create(:user) }

  scenario 'Аутентифицированный пользователь создает вопрос' do
    sign_in(user)
    visit questions_path
    click_on 'New Question'
    fill_in 'question_title', with: 'Тестовый заголовок вопроса'
    fill_in 'question_body', with: 'Тестовый текст вопроса'
    click_on 'Create Question'
    expect(page).to have_content 'Тестовый заголовок вопроса'
    expect(page).to have_content 'Тестовый текст вопроса'
  end

  scenario 'Неаутентифицированный пользователь пытается создать вопрос' do
    visit questions_path
    expect(page).to_not have_link 'Ask question'
  end

  scenario 'Пользователь пытается создать вопрос с пустыми полями' do
    sign_in(user)
    visit questions_path
    click_on 'New Question'
    click_on 'Create Question'
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end
end
