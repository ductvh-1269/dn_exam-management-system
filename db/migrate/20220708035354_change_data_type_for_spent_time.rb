class ChangeDataTypeForSpentTime < ActiveRecord::Migration[6.1]
  def change
    change_table :exams do |t|
      t.change :spent_time, :integer
    end
  end
end
