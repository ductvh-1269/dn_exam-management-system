class ChangeColumnNameInExamDetail < ActiveRecord::Migration[6.1]
  def change
    rename_column :exam_details, :history_id, :exam_id
  end
end
