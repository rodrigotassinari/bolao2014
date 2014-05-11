class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :body_en, null: false
      t.string :body_pt, null: false
      t.datetime :played_at, null: false
      t.string :answer_type, null: false
      t.string :answer

      t.timestamps
    end
  end
end
