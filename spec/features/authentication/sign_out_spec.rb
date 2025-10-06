require 'rails_helper'

feature 'Пользователь выходит из системы' do
  given(:user) { create(:user) }

  scenario 'Пользователь выходит из системы' do
    sign_in(user)
    visit root_path
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully'
  end
end
