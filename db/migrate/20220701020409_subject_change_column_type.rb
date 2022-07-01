class SubjectChangeColumnType < ActiveRecord::Migration[6.1]
  def change
    change_column(:subjects, :status, :integer)
  end
end
