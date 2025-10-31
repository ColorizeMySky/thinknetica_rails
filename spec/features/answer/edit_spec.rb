require 'rails_helper'

feature 'Редактирование ответа' do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Автор редактирует свой ответ', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Edit'

    within '.edit-answer' do
      fill_in 'answer_body', with: 'Отредактированный ответ'
      click_on 'Save'
    end

    expect(page).to have_content 'Отредактированный ответ'
    expect(page).not_to have_selector '.edit-answer'
  end

    scenario 'Автор добавляет файлы при редактировании ответа', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Edit'

    within '.edit-answer' do
      attach_file 'Files', [ "#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]
      click_on 'Save'
    end

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end

  scenario 'Не автор не может редактировать ответ' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  scenario 'Неаутентифицированный пользователь не может редактировать ответ' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end
