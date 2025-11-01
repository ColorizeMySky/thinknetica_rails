require 'rails_helper'

feature 'Пользователь может добавить ссылки к вопросу' do
  given(:user) { create(:user) }

  before do
    sign_in(user)
    visit new_question_path
  end

  scenario 'Пользователь добавляет ссылку при создании вопроса', js: true do
    fill_in 'question_title', with: 'Test question'
    fill_in 'question_body', with: 'text text text'
    fill_in 'question_links_attributes_0_name', with: 'My link'
    fill_in 'question_links_attributes_0_url', with: 'https://example.com'

    click_on 'Create Question'

    expect(page).to have_link 'My link', href: 'https://example.com'
  end

  scenario 'Пользователь добавляет gist ссылку и видит содержимое gist', js: true do
    fill_in 'question_title', with: 'Test question'
    fill_in 'question_body', with: 'text text text'
    fill_in 'question_links_attributes_0_name', with: 'My gist'
    fill_in 'question_links_attributes_0_url', with: 'https://gist.github.com/ColorizeMySky/007acb1d9ff16655821bdbf2e7f5dcb3'

    click_on 'Create Question'

    expect(page).to have_css 'script[src="https://gist.github.com/ColorizeMySky/007acb1d9ff16655821bdbf2e7f5dcb3.js"]', visible: false
  end

  scenario 'Пользователь добавляет несколько ссылок при создании вопроса', js: true do
    fill_in 'question_title', with: 'Test question'
    fill_in 'question_body', with: 'text text text'
    fill_in 'question_links_attributes_0_name', with: 'First link'
    fill_in 'question_links_attributes_0_url', with: 'https://example1.com'

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Second link'
      fill_in 'Url', with: 'https://example2.com'
    end

    click_on 'Create Question'

    expect(page).to have_link 'First link', href: 'https://example1.com'
    expect(page).to have_link 'Second link', href: 'https://example2.com'
  end

  scenario 'Пользователь добавляет невалидную ссылку при создании вопроса', js: true do
    fill_in 'question_title', with: 'Test question'
    fill_in 'question_body', with: 'text text text'
    fill_in 'question_links_attributes_0_name', with: 'Invalid link'
    fill_in 'question_links_attributes_0_url', with: 'invalid_url'

    expect {
      click_on 'Create Question'
    }.not_to change(Question, :count)

    expect(page).to have_content 'Links url is invalid'
  end
end
