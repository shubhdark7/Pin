class AddBoardIdToPins < ActiveRecord::Migration[5.1]
  def change
    add_column :pins, :board_id, :integer
  end
end
