class CreateSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :subjects do |t|
      t.integer :user_id
      t.boolean :status

      t.timestamps
    end
  end
end
