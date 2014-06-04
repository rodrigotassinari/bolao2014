require 'spec_helper'

describe QuestionsController do

  # GET /questions
  describe '#index' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :index
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'returns http success' do
        get :index
        expect(response).to be_success
      end
      it 'renders the correct template' do
        get :index
        expect(response).to render_template('index')
      end
      it 'assigns all questions, in order, wrapped in a presenter' do
        questions = [mock_model(Question)]
        questions_presenters = [double(QuestionPresenter)]
        Question.should_receive(:all_in_order).and_return(questions)
        QuestionPresenter.should_receive(:map).with(questions).and_return(questions_presenters)
        get :index
        expect(assigns(:_questions)).to eql(questions)
        expect(assigns(:questions)).to eql(questions_presenters)
      end
    end
  end

  # GET /questions/:id
  describe '#show' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :show, id: 42
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      let(:question) { create(:boolean_question) }
      before(:each) { login_user(user) }
      it 'returns http success' do
        get :show, id: question.id
        expect(response).to be_success
      end
      it 'renders the correct template' do
        get :show, id: question.id
        expect(response).to render_template('show')
      end
      it 'assigns the requested question, wrapped in a presenter' do
        question_presenter = double(QuestionPresenter)
        QuestionPresenter.should_receive(:new).with(question).and_return(question_presenter)
        get :show, id: question.id
        expect(assigns(:_question)).to eql(question)
        expect(assigns(:question)).to eql(question_presenter)
      end
    end
  end

end
