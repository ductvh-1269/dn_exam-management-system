class ChangeHistoriesToExams < ActiveRecord::Migration[6.1]
  def change
    rename_table :histories, :exams
  end
end
