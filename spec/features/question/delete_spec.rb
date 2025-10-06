require 'rails_helper'

feature 'Пользователь удаляет вопрос' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Автор удаляет свой вопрос' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete Question'
    expect(page).to have_content 'Question was successfully deleted'
    expect(page).to_not have_content question.title
  end

  scenario 'Не автор не видит кнопку удаления вопроса' do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_link 'Delete Question'
  end

  scenario 'Неаутентифицированный пользователь не видит кнопку удаления вопроса' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete Question'
  end
end
