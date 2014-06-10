require 'spec_helper'

describe UsersController do

  # GET /profile
  describe '#edit' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :edit
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      it 'returns http success' do
        get :edit
        expect(response).to be_success
      end
      it 'renders the correct template' do
        get :edit
        expect(response).to render_template('edit')
      end
      it 'assigns the current user wrapped in a presenter' do
        user_presenter = double(UserPresenter)
        UserPresenter.should_receive(:new).with(user).and_return(user_presenter)
        get :edit
        expect(assigns(:user)).to eql(user_presenter)
      end
    end
  end

  # PUT /profile
  describe '#update' do
    context 'when not logged in' do
      it 'redirects to login' do
        put :edit
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user) }
      before(:each) { login_user(user) }
      context 'with valid profile change' do
        # TODO
      end
      context 'with invalid profile change' do
        # TODO
      end
    end
  end

end
