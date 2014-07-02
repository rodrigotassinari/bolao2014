require 'spec_helper'

describe QuestionBetsController do

  describe '#edit' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :edit, question_id: 42
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      # TODO
    end
  end

  describe '#create' do
    context 'when not logged in' do
      it 'redirects to login' do
        post :create, question_id: 42
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:bet) { create(:bet) }
      let(:user) { bet.user }
      let(:question) { create(:boolean_question) }
      before(:each) { login_user(user) }
      context 'when question is available to betting' do
        it 'should create a question_bet' do
          Timecop.freeze(question.bettable_until - 1.minute) do
            expect(question).to_not be_locked
            expect(question.question_bets.count).to eql(0)

            post :create, {question_id: question.id, question_bet: {answer: 'false'}}
            expect(response).to be_redirect
            expect(flash[:success]).to_not be_blank

            expect(question.question_bets.count).to eql(1)
          end
        end
      end
      context 'when question is locked' do
        it 'should not create a question_bet' do
          Timecop.freeze(question.bettable_until + 1.minute) do
            expect(question).to be_locked
            expect(question.question_bets.count).to eql(0)

            post :create, {question_id: question.id, question_bet: {answer: 'false'}}
            expect(response).to be_success
            expect(flash[:success]).to be_blank
            expect(response).to render_template('edit')

            expect(question.question_bets.count).to eql(0)
          end
        end
      end
    end
  end

  describe '#update' do
    context 'when not logged in' do
      it 'redirects to login' do
        put :update, question_id: 42
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:bet) { create(:bet) }
      let(:user) { bet.user }
      let(:question) { create(:boolean_question) }
      let!(:question_bet) { create(:boolean_question_bet, bet: bet, question: question, answer: 'true') }
      before(:each) { login_user(user) }
      context 'when question is available to betting' do
        it 'should change the question_bet' do
          Timecop.freeze(question.bettable_until - 1.minute) do
            expect(question).to_not be_locked
            expect(question_bet.answer).to eql('true')

            put :update, {question_id: question.id, question_bet: {answer: 'false'}}
            expect(response).to be_redirect
            expect(flash[:success]).to_not be_blank

            question_bet.reload
            expect(question_bet.answer).to eql('false')
          end
        end
      end
      context 'when question is locked' do
        it 'should not change the question_bet' do
          Timecop.freeze(question.bettable_until + 1.minute) do
            expect(question).to be_locked
            expect(question_bet.answer).to eql('true')

            put :update, {question_id: question.id, question_bet: {answer: 'false'}}
            expect(response).to be_success
            expect(flash[:success]).to be_blank
            expect(response).to render_template('edit')

            question_bet.reload
            expect(question_bet.answer).to eql('true')
          end
        end
      end
    end
  end

end
