class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.integer :subject_id
      t.boolean :status
      t.integer :type

      t.timestamps
    end
  end
end
