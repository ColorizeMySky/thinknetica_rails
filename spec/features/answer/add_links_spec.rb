require 'rails_helper'

feature 'Пользователь может добавить ссылки к ответу' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Пользователь добавляет ссылку при создании ответа', js: true do
    fill_in 'answer_body', with: 'Test answer'
    fill_in 'answer_links_attributes_0_name', with: 'My link'
    fill_in 'answer_links_attributes_0_url', with: 'https://example.com'

    click_on 'Post Answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: 'https://example.com'
    end
  end

  scenario 'Пользователь добавляет gist ссылку и видит содержимое gist', js: true do
    fill_in 'answer_body', with: 'Test answer'
    fill_in 'answer_links_attributes_0_name', with: 'My gist'
    fill_in 'answer_links_attributes_0_url', with: 'https://gist.github.com/ColorizeMySky/007acb1d9ff16655821bdbf2e7f5dcb3'

    click_on 'Post Answer'

    within '.answers' do
      expect(page).to have_css 'script[src="https://gist.github.com/ColorizeMySky/007acb1d9ff16655821bdbf2e7f5dcb3.js"]', visible: false
    end
  end

  scenario 'Пользователь добавляет несколько ссылок при создании ответа', js: true do
    fill_in 'answer_body', with: 'Test answer'
    fill_in 'answer_links_attributes_0_name', with: 'First link'
    fill_in 'answer_links_attributes_0_url', with: 'https://example1.com'

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Second link'
      fill_in 'Url', with: 'https://example2.com'
    end

    click_on 'Post Answer'

    within '.answers' do
      expect(page).to have_link 'First link', href: 'https://example1.com'
      expect(page).to have_link 'Second link', href: 'https://example2.com'
    end
  end

  scenario 'Пользователь добавляет невалидную ссылку при создании ответа', js: true do
    fill_in 'answer_body', with: 'Test answer'
    fill_in 'answer_links_attributes_0_name', with: 'Invalid link'
    fill_in 'answer_links_attributes_0_url', with: 'invalid_url'

    expect {
      click_on 'Post Answer'
    }.not_to change(Answer, :count)

    expect(page).to have_content 'Links url is invalid'
  end
end
