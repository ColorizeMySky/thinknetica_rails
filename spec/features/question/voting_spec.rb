require 'rails_helper'

RSpec.describe 'Голосование за вопрос', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  context 'аутентифицированный пользователь' do
    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'голосует за вопрос', js: true do
      within '.question' do
        click_on 'Голосовать за'
        expect(page).to have_content('Рейтинг: 1')
      end
    end

    scenario 'голосует против вопроса', js: true do
      within '.question' do
        click_on 'Голосовать против'
        expect(page).to have_content('Рейтинг: -1')
      end
    end

    scenario 'отменяет голос', js: true do
      within '.question' do
        click_on 'Голосовать за'
        click_on 'Отменить голос'
        expect(page).to have_content('Рейтинг: 0')
      end
    end

    scenario 'может переголосовать', js: true do
      within '.question' do
        click_on 'Голосовать за'
        click_on 'Отменить голос'
        click_on 'Голосовать против'
        expect(page).to have_content('Рейтинг: -1')
      end
    end

    scenario 'может голосовать только один раз' do
      within '.question' do
        click_on 'Голосовать за'
        expect(page).not_to have_button('Голосовать за')
        expect(page).not_to have_button('Голосовать против')
        expect(page).to have_button('Отменить голос')
      end
    end
  end

  context 'неаутентифицированный пользователь' do
    before { visit question_path(question) }

    scenario 'не видит кнопки голосования' do
      within '.question' do
        expect(page).not_to have_button('Голосовать за')
        expect(page).not_to have_button('Голосовать против')
        expect(page).not_to have_button('Отменить голос')
      end
    end
  end

  context 'автор вопроса' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'не может голосовать за свой вопрос' do
      within '.question' do
        expect(page).not_to have_button('Голосовать за')
        expect(page).not_to have_button('Голосовать против')
      end
    end
  end

  scenario 'рейтинг вопроса отображается правильно' do
    another_user = create(:user)

    visit question_path(question)
    within '.question' do
      expect(page).to have_content('Рейтинг: 0')
    end

    sign_in(another_user)
    visit question_path(question)
    within '.question' do
      click_on 'Голосовать за'
      expect(page).to have_content('Рейтинг: 1')
    end

    sign_in(other_user)
    visit question_path(question)
    within '.question' do
      click_on 'Голосовать против'
      expect(page).to have_content('Рейтинг: 0')
    end
  end
end
