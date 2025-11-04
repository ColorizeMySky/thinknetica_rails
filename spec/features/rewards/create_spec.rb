require 'rails_helper'

feature 'Пользователь может добавить награду при создании вопроса' do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'Пользователь добавляет награду при создании вопроса' do
    fill_in 'question_title', with: 'Test question'
    fill_in 'question_body', with: 'text text text'

    fill_in 'Reward title', with: 'Best answer reward'
    attach_file 'Reward image', "#{Rails.root}/spec/fixtures/files/reward.png"

    click_on 'Create Question'

    expect(page).to have_content 'Best answer reward'
    expect(page).to have_css 'img[alt="Best answer reward"]'
  end
end
