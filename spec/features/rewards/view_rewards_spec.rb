require 'rails_helper'

RSpec.feature 'Пользователь просматривает свои награды', type: :feature do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: other_user) }

  context 'Когда пользователь аутентифицирован' do
    before do
      sign_in(user)
      visit rewards_path
    end

    scenario 'видит свои награды' do
      reward = create(:reward, question: question, user: user)
      reward.image.attach(io: File.open("#{Rails.root}/spec/fixtures/files/reward.png"), filename: 'reward.png')

      visit rewards_path

      expect(page).to have_content('My Rewards')
      expect(page).to have_content(reward.title)
      expect(page).to have_content("Question: #{question.title}")
      expect(page).to have_css("img[alt='#{reward.title}']")
    end

    scenario 'видит сообщение когда нет наград' do
      expect(page).to have_content('My Rewards')
      expect(page).to have_content('You have no rewards yet.')
    end

    scenario 'не видит награды других пользователей' do
      other_reward = create(:reward, question: question, user: other_user)

      visit rewards_path

      expect(page).to have_content('You have no rewards yet.')
      expect(page).not_to have_content(other_reward.title)
    end
  end

  context 'Когда пользователь не аутентифицирован' do
    scenario 'не может просматривать награды' do
      visit rewards_path

      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end
end
