class CreateHistoryDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :history_details do |t|
      t.integer :history_id
      t.integer :question_id
      t.integer :selected_answer_id
      t.text :essay_answer

      t.timestamps
    end
  end
end
