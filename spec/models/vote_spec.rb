require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it { should validate_presence_of(:value) }
  it { should validate_inclusion_of(:value).in_array([ -1, 1 ]) }

  describe 'проверка уникальности' do
    let!(:vote) { create(:vote, user: user, votable: question, value: 1) }

    it 'не позволяет пользователю голосовать дважды за один ресурс' do
      duplicate_vote = build(:vote, user: user, votable: question, value: -1)
      expect(duplicate_vote).not_to be_valid
    end
  end
end
