require 'spec_helper'

describe PagesController do

  # GET /help
  describe '#help' do
    it 'returns http success' do
      get :help
      expect(response).to be_success
    end
    it 'renders the template' do
      get :help
      expect(response).to render_template('help')
    end
    it 'assigns the first match, wrapped in presenter' do
      match1 = create(:match, played_at: 2.days.from_now)
      match2 = create(:future_match, played_at: 3.days.from_now)
      get :help
      expect(assigns(:_first_match)).to eql(match1)
      expect(assigns(:first_match)).to be_instance_of(MatchPresenter)
    end
  end

end
