class ChangeHistoryDetailsToExamDetails < ActiveRecord::Migration[6.1]
  def change
    rename_table :history_details, :exam_details
  end
end
