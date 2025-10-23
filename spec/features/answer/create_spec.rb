require 'rails_helper'

feature 'Пользователь отвечает на вопрос' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Аутентифицированный пользователь отвечает на вопрос', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer_body', with: 'Тестовый текст ответа'
    click_on 'Post Answer'

    save_and_open_page
    within '.answers' do
      expect(page).to have_content 'Тестовый текст ответа'
    end
    expect(page).to have_field('answer_body', with: '')
  end

  scenario 'Неаутентифицированный пользователь не может ответить на вопрос' do
    visit question_path(question)
    expect(page).to_not have_button 'Post Answer'
  end

  scenario 'Пользователь пытается создать ответ с пустым телом', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Post Answer'

    save_and_open_page
    expect(page).to have_content "Body can't be blank"
    # expect(page).to have_css('.answer-errors', text: "Body can't be blank")
  end
end
