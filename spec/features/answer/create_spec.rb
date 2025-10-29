require 'rails_helper'

feature 'Пользователь отвечает на вопрос' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'Аутентифицированный пользователь' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Пользователь отвечает на вопрос', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'answer_body', with: 'Тестовый текст ответа'
      click_on 'Post Answer'

      expect(page).to have_css('.answers')
      within '.answers' do
        expect(page).to have_content 'Тестовый текст ответа'
      end
      expect(page).to have_field('answer_body', with: '')
    end

    scenario 'Пользователь пытается создать ответ с пустым телом', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Post Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'Пользователь отвечает на вопрос с одним прикрепленным файлом', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'answer_body', with: 'Ответ с файлом'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Post Answer'

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'Пльзователь отвечает на вопрос с несколькими прикрепленными файлами', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'answer_body', with: 'Ответ с файлами'
      attach_file 'Files', [ "#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]
      click_on 'Post Answer'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  context 'Неаутентифицированный пользователь' do
    scenario 'Пользователь не может ответить на вопрос' do
      visit question_path(question)
      expect(page).to_not have_button 'Post Answer'
    end
  end
end
