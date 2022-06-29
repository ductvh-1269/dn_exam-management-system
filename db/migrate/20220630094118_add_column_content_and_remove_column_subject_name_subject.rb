class AddColumnContentAndRemoveColumnSubjectNameSubject < ActiveRecord::Migration[6.1]
  def change
    add_column :subjects, :content, :string
    remove_column :subjects, :subject_name
  end
end
