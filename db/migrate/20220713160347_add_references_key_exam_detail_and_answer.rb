class AddReferencesKeyExamDetailAndAnswer < ActiveRecord::Migration[6.1]
  def change
    remove_column :exam_details, :selected_answer_id
    add_reference :exam_details, :selected_answer, foreign_key: { to_table: :answers }
  end
end
