require 'spec_helper'

describe Admin::QuestionsController do

  describe '#index' do
    it { expect(get('/admin/questions')).to route_to(controller: 'admin/questions', action: 'index') }
    it { expect(admin_questions_path).to eq('/admin/questions') }
  end

  describe '#show' do
    it { expect(get('/admin/questions/42')).to route_to(controller: 'admin/questions', action: 'show', id: '42') }
    it { expect(admin_question_path(42)).to eq('/admin/questions/42') }
  end

  describe '#edit' do
    it { expect(get('/admin/questions/42/edit')).to route_to(controller: 'admin/questions', action: 'edit', id: '42') }
    it { expect(edit_admin_question_path(42)).to eq('/admin/questions/42/edit') }
  end

  describe '#update' do
    it { expect(put('/admin/questions/42')).to route_to(controller: 'admin/questions', action: 'update', id: '42') }
  end

end
