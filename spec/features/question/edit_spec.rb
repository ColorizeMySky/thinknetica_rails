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

  scenario 'Автор добавляет файлы при редактировании вопроса', js: true do
    sign_in(user)
    visit question_path(question)

    click_link 'Edit'

    within '.edit-question-form' do
      attach_file 'Files', [ "#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]
      click_on 'Update Question'
    end

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
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
