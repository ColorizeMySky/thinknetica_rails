require 'rails_helper'

feature 'Пользователь удаляет ответ' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Автор удаляет свой ответ', js: true do
    sign_in(user)
    visit question_path(question)

    accept_confirm do
      click_on 'Delete Answer'
    end

    expect(page).to have_content 'Answer was successfully deleted'
    expect(page).to_not have_content answer.body
  end

  scenario 'Автор удаляет файл из своего ответа', js: true do
    answer.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')), filename: 'rails_helper.rb')
    answer.save!

    sign_in(user)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      accept_confirm do
        click_on 'Delete file'
      end
    end

    expect(page).not_to have_link 'rails_helper.rb'
  end

  scenario 'Не автор не видит кнопку удаления ответа' do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_link 'Delete Answer'
  end

  scenario 'Не автор не видит кнопку удаления файлов ответа' do
    other_answer = create(:answer, question: question, user: other_user)
    other_answer.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')), filename: 'rails_helper.rb')
    other_answer.save!

    sign_in(user)
    visit question_path(question)

    within "#answer_#{other_answer.id}" do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).not_to have_button 'Delete file'
    end
  end

  scenario 'Неаутентифицированный пользователь не видит кнопку удаления ответа' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete Answer'
  end

  scenario 'Неаутентифицированный пользователь не может удалить файл ответа' do
    answer.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')), filename: 'rails_helper.rb')
    answer.save!
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).not_to have_button 'Delete file'
    end
  end
end
