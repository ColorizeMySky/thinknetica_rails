require 'rails_helper'

feature 'Выбор лучшего ответа' do
  given!(:author) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: other_user) }

  scenario 'Автор выбирает лучший ответ', js: true do
    sign_in(author)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      click_on 'Mark as best'
    end

    expect(page).to have_content 'Best answer selected'
  end

  scenario 'Автор меняет лучший ответ', js: true do
    another_answer = create(:answer, question: question, user: other_user)
    sign_in(author)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      click_on 'Mark as best'
    end

    within "#answer_#{another_answer.id}" do
      click_on 'Mark as best'
    end

    expect(page).to have_content 'Best answer selected'
  end

  scenario 'Не автор не видит кнопку выбора лучшего ответа' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).not_to have_button 'Mark as best'
  end

  scenario 'Неаутентифицированный пользователь не видит кнопку выбора лучшего ответа' do
    visit question_path(question)

    expect(page).not_to have_button 'Mark as best'
  end

  scenario 'Лучший ответ отображается первым', js: true do
    another_answer = create(:answer, question: question, user: other_user)
    sign_in(author)
    visit question_path(question)

    within "#answer_#{another_answer.id}" do
      click_on 'Mark as best'
    end

    first_answer = find('.answers .answer:first-child')
    expect(first_answer).to have_content another_answer.body
    expect(first_answer).to have_content 'Best answer'
  end
end
