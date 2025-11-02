require 'rails_helper'

feature 'Автор может редактировать ссылки ответа' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable: answer, name: 'Old link', url: 'https://old.example.com') }

  scenario 'Автор удаляет ссылку у своего ответа', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      click_on 'Edit'
    end

    within "#answer_#{answer.id} #answer-links .nested-fields" do
      click_on 'Remove link'
    end

    # click_on 'Save'
    visit question_path(question)

    expect(page).not_to have_link 'Old link'
  end

  scenario 'Автор добавляет новую ссылку при редактировании ответа', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      click_on 'Edit'
    end

    within "#answer_#{answer.id} #answer-links" do
      click_on 'Add link'
    end

    within "#answer_#{answer.id} #answer-links .nested-fields:last-child" do
      fill_in 'Link name', with: 'New link'
      fill_in 'Url', with: 'https://new.example.com'
    end

    click_on 'Save'

    expect(page).to have_link 'New link', href: 'https://new.example.com'
  end
end
