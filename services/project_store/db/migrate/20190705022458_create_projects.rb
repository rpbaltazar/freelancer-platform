class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.float :hourly_rate
      t.string :currency

      t.timestamps
    end
  end
end
