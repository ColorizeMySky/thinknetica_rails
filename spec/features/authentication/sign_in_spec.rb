require 'rails_helper'

feature 'Пользователь входит в систему' do
  given(:user) { create(:user) }

  scenario 'Пользователь входит в систему' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'Пользователь пытается войти с невалидными данными' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'wrongpassword'
    click_button 'Log in'
    expect(page).to have_content 'Invalid Email or password'
  end
end