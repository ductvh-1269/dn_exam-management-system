class AddSubjectNameToSubject < ActiveRecord::Migration[6.1]
  def change
    add_column :subjects, :name, :string
  end
end
