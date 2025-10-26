require 'rails_helper'

feature 'Редактирование вопроса' do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Автор редактирует свой вопрос', js: true do
    sign_in(user)
    visit question_path(question)

    click_link 'Edit'

    fill_in 'question_title', with: 'Отредактированный заголовок'
    fill_in 'question_body', with: 'Отредактированное тело'
    click_on 'Update Question'

    expect(page).to have_content 'Отредактированный заголовок'
    expect(page).to have_content 'Отредактированное тело'
    expect(page).not_to have_selector 'input#question_title'
  end

  scenario 'Не автор не может редактировать вопрос' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  scenario 'Неаутентифицированный пользователь не может редактировать вопрос' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end
