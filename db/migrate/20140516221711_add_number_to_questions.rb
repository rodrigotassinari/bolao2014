class AddNumberToQuestions < ActiveRecord::Migration
  def up
    add_column :questions, :number, :integer
    Question.reset_column_information
    Question.update_all('number = id')
    change_column :questions, :number, :integer, null: false
    add_index :questions, :number, unique: true
  end

  def down
    remove_column :questions, :number, :integer
  end
end
