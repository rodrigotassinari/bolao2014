class AddAnswerScopeToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :answer_scope, :string
  end
end
