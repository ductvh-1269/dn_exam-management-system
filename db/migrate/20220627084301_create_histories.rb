class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.integer :user_id
      t.integer :subject_id
      t.datetime :spent_time
      t.integer :status
      t.float :score

      t.timestamps
    end
  end
end
