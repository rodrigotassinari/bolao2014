require 'spec_helper'

describe Question do

  context 'associations' do
    it { should have_many(:question_bets) }
  end

  context 'validations' do
    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number) }

    it { should validate_presence_of(:body_en) }
    it { should validate_uniqueness_of(:body_en).case_insensitive }

    it { should validate_presence_of(:body_pt) }
    it { should validate_uniqueness_of(:body_pt).case_insensitive }

    it { should validate_presence_of(:played_at) }

    it { should validate_presence_of(:answer_type,) }
    it { should ensure_inclusion_of(:answer_type).in_array(Question::ANSWER_TYPES) }

    it 'validates that the answer must be a valid Team id when the answer_type is `team`', locale: :pt do
      team = create(:team)
      question = build(:team_question, answer: '42')

      expect(question).to_not be_valid
      expect(question.errors.get(:answer)).to eql(['não é válido'])

      question.answer = team.id.to_s
      expect(question).to be_valid
    end
    it 'validates that the answer must be a valid Player id when the answer_type is `player`' do
      player = create(:field_player)
      question = build(:player_question, answer: '42')

      expect(question).to_not be_valid
      expect(question.errors.get(:answer)).to eql(['não é válido'])

      question.answer = player.id.to_s
      expect(question).to be_valid
    end
    it 'validates that the answer must be a true or false when the answer_type is `boolean`', locale: :pt do
      question = build(:boolean_question, answer: 'opa')

      expect(question).to_not be_valid
      expect(question.errors.get(:answer)).to eql(['não é válido'])

      question.answer = 'true'
      expect(question).to be_valid
    end
  end

  describe 'scopes' do
    describe '.hours_from_being_played' do
      let!(:question1) { create(:boolean_question, number: 1, body_en: '1 en', body_pt: '1 pt', played_at: '2014-06-12 17:00:00 -0300'.to_time) }
      let!(:question2) { create(:boolean_question, number: 2, body_en: '2 en', body_pt: '2 pt', played_at: '2014-06-12 18:00:00 -0300'.to_time) }
      let!(:question3) { create(:boolean_question, number: 3, body_en: '3 en', body_pt: '3 pt', played_at: '2014-06-12 18:00:00 -0300'.to_time) }
      let!(:question4) { create(:boolean_question, number: 4, body_en: '4 en', body_pt: '4 pt', played_at: '2014-06-12 19:00:00 -0300'.to_time) }
      let!(:question5) { create(:boolean_question, number: 5, body_en: '5 en', body_pt: '5 pt', played_at: '2014-06-12 19:00:01 -0300'.to_time) }
      it 'returns questions all questions with at least X hours before starting' do
        Timecop.freeze('2014-06-12 17:00:00 -0300'.to_time) do
          expect(described_class.hours_from_being_played(-1).count).to eq(0)
          expect(described_class.hours_from_being_played(-1).order(number: :asc).pluck(:number)).to eq([])

          expect(described_class.hours_from_being_played(0).count).to eq(1)
          expect(described_class.hours_from_being_played(0).order(number: :asc).pluck(:number)).to eq([1])

          expect(described_class.hours_from_being_played(1).count).to eq(3)
          expect(described_class.hours_from_being_played(1).order(number: :asc).pluck(:number)).to eq([1, 2, 3])

          expect(described_class.hours_from_being_played(2).count).to eq(4)
          expect(described_class.hours_from_being_played(2).order(number: :asc).pluck(:number)).to eq([1, 2, 3, 4])

          expect(described_class.hours_from_being_played(5).count).to eq(5)
          expect(described_class.hours_from_being_played(5).order(number: :asc).pluck(:number)).to eq([1, 2, 3, 4, 5])
        end
      end
    end
    describe '.hours_from_being_locked' do
      let!(:question1) { create(:boolean_question, number: 1, body_en: '1 en', body_pt: '1 pt', played_at: '2014-06-12 17:00:00 -0300'.to_time) } # locks at 16:00
      let!(:question2) { create(:boolean_question, number: 2, body_en: '2 en', body_pt: '2 pt', played_at: '2014-06-12 18:00:00 -0300'.to_time) } # locks at 17:00
      let!(:question3) { create(:boolean_question, number: 3, body_en: '3 en', body_pt: '3 pt', played_at: '2014-06-12 18:00:00 -0300'.to_time) } # locks at 17:00
      let!(:question4) { create(:boolean_question, number: 4, body_en: '4 en', body_pt: '4 pt', played_at: '2014-06-12 19:00:00 -0300'.to_time) } # locks at 18:00
      let!(:question5) { create(:boolean_question, number: 5, body_en: '5 en', body_pt: '5 pt', played_at: '2014-06-12 19:00:01 -0300'.to_time) } # locks at 18:01
      it 'returns questions with at least X hours before being locked for betting' do
        Timecop.freeze('2014-06-12 15:00:00 -0300'.to_time) do
          expect(described_class.hours_from_being_locked(-1).count).to eq(0)
          expect(described_class.hours_from_being_locked(-1).order(number: :asc).pluck(:number)).to eq([])

          expect(described_class.hours_from_being_locked(0).count).to eq(0)
          expect(described_class.hours_from_being_locked(0).order(number: :asc).pluck(:number)).to eq([])

          expect(described_class.hours_from_being_locked(1).count).to eq(1)
          expect(described_class.hours_from_being_locked(1).order(number: :asc).pluck(:number)).to eq([1])

          expect(described_class.hours_from_being_locked(2).count).to eq(3)
          expect(described_class.hours_from_being_locked(2).order(number: :asc).pluck(:number)).to eq([1, 2, 3])

          expect(described_class.hours_from_being_locked(5).count).to eq(5)
          expect(described_class.hours_from_being_locked(5).order(number: :asc).pluck(:number)).to eq([1, 2, 3, 4, 5])
        end
      end
    end
  end

  describe '#body' do
    subject { build(:team_question, body_en: 'Foo', body_pt: 'Fú') }
    it 'returns the :pt body', locale: :pt do
      expect(subject.body).to eql('Fú')
    end
    # it 'returns the :en body', locale: :en do
    #   expect(subject.body).to eql('Foo')
    # end
  end

  describe '#answer_object' do
    let(:team) { create(:team) }
    let(:player) { create(:field_player) }
    it 'returns nil without an answer set' do
      expect(subject.answer_object).to be_nil
    end
    context 'with team type question' do
      subject { build(:team_question, answer: team.id.to_s) }
      it 'returns the Team object' do
        expect(subject.answer_object).to eql(team)
      end
    end
    context 'with player type question' do
      subject { build(:player_question, answer: player.id.to_s) }
      it 'returns the Team object' do
        expect(subject.answer_object).to eql(player)
      end
    end
    context 'with boolean type question' do
      subject { build(:boolean_question, answer: 'false') }
      it 'returns the Team object' do
        expect(subject.answer_object).to be_false
      end
    end
  end

  describe '#locked?' do
    let(:question) { build(:boolean_question) }
    let(:limit) { described_class.hours_before_start_time_to_bet }
    it 'returns false for more than 1 hour before the question start' do
      Timecop.freeze(question.played_at - (limit * 60 + 1).minutes) do
        expect(question).to_not be_locked
      end
    end
    it 'returns true when 1 hour before the question start' do
      Timecop.freeze(question.played_at - limit.hour) do
        expect(question).to be_locked
      end
    end
    it 'returns true when less than 1 hour before the question start' do
      Timecop.freeze(question.played_at - (limit * 60 - 1).minutes) do
        expect(question).to be_locked
      end
    end
    it 'returns true after the question has started' do
      Timecop.freeze(question.played_at + 1.minute) do
        expect(question).to be_locked
      end
    end
  end

  describe '#bettable?' do
    let(:question) { build(:boolean_question) }
    let(:limit) { described_class.hours_before_start_time_to_bet }
    it 'returns true for more than 1 hour before the question start' do
      Timecop.freeze(question.played_at - (limit * 60 + 1).minutes) do
        expect(question).to be_bettable
      end
    end
    it 'returns false when 1 hour before the question start' do
      Timecop.freeze(question.played_at - limit.hour) do
        expect(question).to_not be_bettable
      end
    end
    it 'returns false when less than 1 hour before the question start' do
      Timecop.freeze(question.played_at - (limit * 60 - 1).minutes) do
        expect(question).to_not be_bettable
      end
    end
    it 'returns false after the question has started' do
      Timecop.freeze(question.played_at + 1.minute) do
        expect(question).to_not be_bettable
      end
    end
  end

  describe '#score!' do
    subject { build(:boolean_question) }
    it 'delegates to QuestionScorer#score_all!' do
      question_scorer = double('QuestionScorer', score_all!: true)
      QuestionScorer.should_receive(:new).with(subject).and_return(question_scorer)
      question_scorer.should_receive(:score_all!)
      subject.score!
    end
  end

end
