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

  scenario 'Автор удаляет файл из своего вопроса', js: true do
    question.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')), filename: 'rails_helper.rb')
    question.save!

    sign_in(user)
    visit question_path(question)

    within '.question' do
      accept_confirm do
        click_on 'Delete file'
      end
    end

    expect(page).not_to have_link 'rails_helper.rb'
  end

  scenario 'Не автор не видит кнопку удаления вопроса' do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_link 'Delete Question'
  end

  scenario 'Не автор не видит кнопку удаления только для своих файлов вопроса' do
    other_question = create(:question, user: other_user)
    other_question.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')), filename: 'rails_helper.rb')

    sign_in(user)
    visit question_path(other_question)

    expect(page).to have_link 'rails_helper.rb'
    expect(page).not_to have_button 'Delete file'
  end

  scenario 'Неаутентифицированный пользователь не видит кнопку удаления вопроса' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete Question'
  end

  scenario 'Неаутентифицированный пользователь не может удалить файл вопроса' do
    question.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')), filename: 'rails_helper.rb')
    visit question_path(question)

    expect(page).to have_link 'rails_helper.rb'
    expect(page).not_to have_button 'Delete file'
  end
end
