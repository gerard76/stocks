class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.string  :symbol
      t.string  :name
      t.date    :date
      t.decimal :open
      t.decimal :close
      t.decimal :high
      t.decimal :low
      t.timestamps
    end
    
    add_index :quotes, [:symbol, :date]
  end
  
  def self.down
    drop_table :quotes
  end
end
