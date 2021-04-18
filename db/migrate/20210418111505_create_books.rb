class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.datetime :sales_enqueued_at
      t.datetime :sales_calculated_at
      t.boolean :crunching_sales

      t.timestamps
    end
  end
end
