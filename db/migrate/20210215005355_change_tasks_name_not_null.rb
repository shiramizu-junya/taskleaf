class ChangeTasksNameNotNull < ActiveRecord::Migration[5.2]
  def change
    # tasksテーブルのnameカラムにNotNull制約をつける
    change_column_null :tasks, :name, false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
