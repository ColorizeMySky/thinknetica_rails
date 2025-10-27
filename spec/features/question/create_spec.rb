require 'rails_helper'

feature 'Пользователь создает вопрос' do
  given(:user) { create(:user) }

  context 'Аутентифицированный пользователь' do
    before do
      sign_in(user)
      visit questions_path
      click_on 'New Question'
    end

    scenario 'Пользователь создает вопрос' do
      fill_in 'question_title', with: 'Тестовый заголовок вопроса'
      fill_in 'question_body', with: 'Тестовый текст вопроса'
      click_on 'Create Question'
      expect(page).to have_content 'Тестовый заголовок вопроса'
      expect(page).to have_content 'Тестовый текст вопроса'
    end

    scenario 'Пользователь создает вопрос с одним прикрепленным файлом' do
      fill_in 'question_title', with: 'Вопрос с файлом'
      fill_in 'question_body', with: 'Текст вопроса с файлом'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create Question'

      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'Пользователь создает вопрос с несколькими прикрепленными файлами' do
      fill_in 'question_title', with: 'Вопрос с файлами'
      fill_in 'question_body', with: 'Текст вопроса с файлами'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'Пользователь пытается создать вопрос с пустыми полями' do
      click_on 'Create Question'
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'Неаутентифицированный пользователь' do
    scenario 'Неаутентифицированный пользователь пытается создать вопрос' do
      visit questions_path
      expect(page).to_not have_link 'New Question'
    end
  end
end
