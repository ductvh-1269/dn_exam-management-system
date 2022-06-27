class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.int :user_id
      t.int :subject_id
      t.datetime :spent_time
      t.int :status
      t.float :score

      t.timestamps
    end
  end
end
