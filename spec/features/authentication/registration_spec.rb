require 'rails_helper'

feature 'Пользователь регистрируется в системе' do
  scenario 'Пользователь регистрируется в системе' do
    visit new_user_registration_path
    fill_in 'Email', with: attributes_for(:user)[:email]
    fill_in 'Password', with: attributes_for(:user)[:password]
    fill_in 'Password confirmation', with: attributes_for(:user)[:password]
    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully'
  end

  scenario 'Пользователь пытается зарегистрироваться с невалидными данными' do
    visit new_user_registration_path
    fill_in 'Email', with: 'invalid-email'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '456'
    click_button 'Sign up'
    expect(page).to have_content 'error'
  end
end
