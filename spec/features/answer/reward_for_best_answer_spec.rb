require 'rails_helper'

feature 'Награждение за лучший ответ' do
  given(:author) { create(:user) }
  given(:answer_author) { create(:user) }

  scenario 'Автор создает вопрос с наградой' do
    sign_in(author)
    visit new_question_path

    fill_in 'question_title', with: 'Test question'
    fill_in 'question_body', with: 'text text text'
    fill_in 'question_reward_attributes_title', with: 'Best answer reward'
    attach_file 'question_reward_attributes_image', "#{Rails.root}/spec/fixtures/files/reward.png"

    click_on 'Create Question'

    expect(page).to have_content 'Best answer reward'
  end

  scenario 'Автор награждает лучший ответ' do
    question = create(:question, user: author)
    create(:reward, question: question)
    answer = create(:answer, question: question, user: answer_author)

    sign_in(author)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      click_on 'Mark as best'
    end

    expect(answer_author.rewards).to include(question.reward)
  end

  scenario 'Пользователь видит полученную награду' do
    question = create(:question, user: author)
    create(:reward, question: question)
    answer = create(:answer, question: question, user: answer_author)
    answer.mark_as_best

    sign_in(answer_author)
    visit rewards_path

    expect(page).to have_content 'Best answer reward'
    expect(page).to have_content question.title
  end
end
