class AddTimes < ActiveRecord::Migration
  def change
    change_table(:posts) { |t| t.timestamps }
  end
end
