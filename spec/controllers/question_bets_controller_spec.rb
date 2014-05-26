require 'spec_helper'

describe QuestionBetsController do

  before { create(:team_question) }

  describe '#edit' do
    it "redirect back to home if questions module is disabled" do
      Question.destroy_all
      get :edit, question_id: 42
      expect(response).to redirect_to(root_path)
    end
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
    it "redirect back to home if questions module is disabled" do
      Question.destroy_all
      post :create, question_id: 42
      expect(response).to redirect_to(root_path)
    end

    context 'when not logged in' do
      it 'redirects to login' do
        post :create, question_id: 42
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

  describe '#update' do
    it "redirect back to home if questions module is disabled" do
      Question.destroy_all
      put :update, question_id: 42
      expect(response).to redirect_to(root_path)
    end
    context 'when not logged in' do
      it 'redirects to login' do
        put :update, question_id: 42
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

end
