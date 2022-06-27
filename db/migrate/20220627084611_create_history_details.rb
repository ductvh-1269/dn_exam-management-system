class CreateHistoryDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :history_details do |t|
      t.int :history_id
      t.int :question_id
      t.int :selected_answer_id
      t.text :essay_answer

      t.timestamps
    end
  end
end
