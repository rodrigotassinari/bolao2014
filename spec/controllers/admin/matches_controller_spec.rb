require 'spec_helper'

describe Admin::MatchesController do

  # GET /admin/matches
  describe ':index' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :index
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in but not an admin' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'redirects to root' do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to_not be_blank
      end
    end
    context 'when logged and is an admin' do
      let(:user) { build(:admin_user) }
      before(:each) { login_user(user) }
      it 'returns http success' do
        get :index
        expect(response).to be_success
        expect(response).to render_template('index')
      end
      it 'assigns all matches, in order, wrapped in a presenter' do
        matches = [mock_model(Match)]
        matches_presenters = [double(MatchPresenter)]
        Match.should_receive(:all_in_order).and_return(matches)
        MatchPresenter.should_receive(:map).with(matches).and_return(matches_presenters)
        get :index
        expect(assigns(:_matches)).to eql(matches)
        expect(assigns(:matches)).to eql(matches_presenters)
      end
    end
  end

  # GET /admin/matches/:id
  describe '#show' do
    let(:match) { create(:match) }
    context 'when not logged in' do
      it 'redirects to login' do
        get :show, id: match.id
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in but not an admin' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'redirects to root' do
        get :show, id: match.id
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to_not be_blank
      end
    end
    context 'when logged and is an admin' do
      let(:user) { build(:admin_user) }
      before(:each) { login_user(user) }
      it 'returns http success with the correct template' do
        get :show, id: match.id
        expect(response).to be_success
        expect(response).to render_template('show')
      end
      it 'assigns the requested match, wrapped in a presenter' do
        match_presenter = double(MatchPresenter)
        MatchPresenter.should_receive(:new).with(match).and_return(match_presenter)
        get :show, id: match.id
        expect(assigns(:_match)).to eql(match)
        expect(assigns(:match)).to eql(match_presenter)
      end
    end
  end

  # GET /admin/matches/:id/edit
  describe '#edit' do
    let(:match) { create(:match) }
    context 'when not logged in' do
      it 'redirects to login' do
        get :edit, id: match.id
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in but not an admin' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'redirects to root' do
        get :edit, id: match.id
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to_not be_blank
      end
    end
    context 'when logged and is an admin' do
      let(:user) { build(:admin_user) }
      before(:each) { login_user(user) }
      it 'returns http success with the correct template' do
        get :edit, id: match.id
        expect(response).to be_success
        expect(response).to render_template('edit')
      end
      it 'assigns the requested match, wrapped in a presenter' do
        match_presenter = double(MatchPresenter)
        MatchPresenter.should_receive(:new).with(match).and_return(match_presenter)
        get :edit, id: match.id
        expect(assigns(:_match)).to eql(match)
        expect(assigns(:match)).to eql(match_presenter)
      end
    end
  end

  # PUT /admin/matches/:id
  describe '#update' do
    let(:match) { create(:match) }
    let(:params) { {id: match.id, match: {'goals_a'=>'2', 'goals_b'=>'1'}} }
    context 'when not logged in' do
      it 'redirects to login' do
        put :update, params
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in but not an admin' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'redirects to root' do
        put :update, params
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to_not be_blank
      end
    end
    context 'when logged and is an admin' do
      let(:user) { build(:admin_user) }
      before(:each) { login_user(user) }
      it 'assigns the requested match, wrapped in a presenter' do
        match_presenter = double(MatchPresenter)
        MatchPresenter.should_receive(:new).with(match).and_return(match_presenter)
        put :update, params
        expect(assigns(:_match)).to eql(match)
        expect(assigns(:match)).to eql(match_presenter)
      end
      context 'with valid params' do
        let!(:updater) { MatchUpdater.new(match, params[:match]) }
        it 'updates the match' do
          MatchUpdater.should_receive(:new).
            with(match, params[:match]).
            and_return(updater)
          updater.should_receive(:save).and_return(true)
          updater.stub(:message).and_return('Something unique')

          put :update, params
        end
        it 'redirects to the match page with a success message' do
          MatchUpdater.stub(:new).and_return(updater)
          updater.stub(:save).and_return(true)
          updater.should_receive(:message).and_return('Something unique')

          put :update, params
          expect(response).to redirect_to(admin_match_path(match))
          expect(flash[:success]).to eq('Something unique')
        end
      end
      context 'with invalid params' do
        let(:params) { {id: match.id, match: {'goals_a'=>'2', 'goals_b'=>'invalid'}} }
        it 'renders the edit page with errors' do
          put :update, params
          expect(response).to be_success
          expect(response).to render_template('edit')
          expect(assigns(:match).errors).to_not be_empty
        end
      end
    end
  end

end
