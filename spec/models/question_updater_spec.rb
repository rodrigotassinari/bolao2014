require 'spec_helper'

describe QuestionUpdater do

  describe '.new' do
    let(:question) { build(:boolean_question) }
    let(:changes) { {'answer'=>'false'} }
    it 'instanciates a new updater with the question and changes set' do
      updater = described_class.new(question, changes)
      expect(updater.question).to eql(question)
      expect(updater.changes).to eql(changes)
      updater.changes = {}
      expect(updater.changes).to be_empty
    end
  end

  describe '#valid?' do
    it 'raises an error when question is new record' do
      question = build(:boolean_question)
      updater = described_class.new(question, {'answer'=>'true'})
      expect { updater.valid? }.to raise_error(ArgumentError, 'question is not persisted')
    end
    it 'raises an error when there is nothing to change on the question' do
      question = create(:boolean_question)
      updater = described_class.new(question, {})
      expect { updater.valid? }.to raise_error(ArgumentError, 'nothing to change on the question')
    end
    it 'returns true' do
      question = create(:boolean_question)
      updater = described_class.new(question, {'answer'=>'true'})
      expect(updater.valid?).to be_true
    end
  end

  describe '#save' do
    let(:boolean_question) { create(:boolean_question, answer: nil) }
    let(:team_question) { create(:team_question, answer: nil) }
    let(:player_question) { create(:player_question, answer: nil) }
    context 'when question is not changed' do
      it 'returns false' do
        updater = described_class.new(boolean_question, {'played_at' => boolean_question.played_at}) # no real change
        expect(updater.save).to be_false
        expect(updater.message).to be_nil
      end
      it 'returns the errors', locale: :pt do
        updater = described_class.new(team_question, {'answer' => 'true'}) # invalid change
        expect(updater.save).to be_false
        expect(updater.message).to be_nil
        expect(updater.errors).to_not be_empty
        expect(updater.errors.get(:answer)).to eq(['não é válido'])
      end
    end
    context 'when question is changed', locale: :pt do
      it 'changes the question' do
        boolean_question.stub(:locked?).and_return(false)
        expect(boolean_question.answer).to be_nil
        updater = described_class.new(boolean_question, {'answer' => 'true'})
        expect(updater.save).to be_true
        expect(updater.message).to eq('Pergunta alterada.')
        expect(boolean_question.answer).to eq('true')
        expect(boolean_question.answer_object).to be_true
      end
      it 'scores the question if question becomes scorable' do
        boolean_question.stub(:locked?).and_return(true)
        QuestionScoreWorker.should_receive(:perform_async).with(boolean_question.id)

        expect(boolean_question).to_not be_scorable
        updater = described_class.new(boolean_question, {'answer' => 'true'})
        expect(updater.save).to be_true
        expect(updater.message).to eq('Pergunta alterada. Pontos de respostas sobre esta pergunta (re-)calculados.')
        expect(boolean_question).to be_scorable
      end
      it 'does not score the question if question does not become scorable' do
        boolean_question.stub(:locked?).and_return(true)
        QuestionScoreWorker.should_not_receive(:perform_async)

        expect(boolean_question).to_not be_scorable
        updater = described_class.new(boolean_question, {'played_at' => boolean_question.played_at + 1.hour})
        expect(updater.save).to be_true
        expect(updater.message).to eq('Pergunta alterada.')
        expect(boolean_question).to_not be_scorable
      end
    end
  end

end
