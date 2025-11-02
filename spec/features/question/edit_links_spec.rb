require 'rails_helper'

feature 'Автор может редактировать ссылки вопроса' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question, name: 'Old link', url: 'https://old.example.com') }

  scenario 'Автор удаляет ссылку у своего вопроса' do
    sign_in(user)
    visit question_path(question)

    click_on 'Edit'

    within all('.nested-fields').first do
      click_on 'Remove link'
    end

    visit question_path(question)


    expect(page).not_to have_link 'Old link'
  end

  scenario 'Автор добавляет новую ссылку при редактировании вопроса', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Edit'

    within '#links' do
      click_on 'Add link'
    end

    new_fields = find('#links .nested-fields:last-child')

    within new_fields do
      fill_in 'Link name', with: 'New link'
      fill_in 'Url', with: 'https://new.example.com'
    end

    click_on 'Update Question'

    expect(page).to have_link 'New link', href: 'https://new.example.com'
  end
end
