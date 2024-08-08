class ChangeDefaultValueSubjects < ActiveRecord::Migration[6.1]
  def change
    change_column_default :subjects, :status, true
  end
end
