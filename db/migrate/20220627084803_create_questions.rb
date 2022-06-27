class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.int :subject_id
      t.boolean :status
      t.int :type

      t.timestamps
    end
  end
end
