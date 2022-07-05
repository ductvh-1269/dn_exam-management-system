class ChangeTypeQuestionStatus < ActiveRecord::Migration[6.1]
  def change
    change_column :questions, :status, :integer
    change_column :answers, :is_correct, :integer
  end
end
