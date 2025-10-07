require 'rails_helper'

feature 'Пользователь удаляет ответ' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Автор удаляет свой ответ' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete Answer'
    expect(page).to have_content 'Answer was successfully deleted'
    expect(page).to_not have_content answer.body
  end

  scenario 'Не автор не видит кнопку удаления ответа' do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_link 'Delete Answer'
  end

  scenario 'Неаутентифицированный пользователь не видит кнопку удаления ответа' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete Answer'
  end
end
