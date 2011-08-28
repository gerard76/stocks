class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.string  :symbol
      t.string  :name
      t.date    :date
      t.decimal :open, :scale => 2, :precision => 10
      t.decimal :close, :scale => 2, :precision => 10
      t.decimal :high, :scale => 2, :precision => 10
      t.decimal :low, :scale => 2, :precision => 10
      t.timestamps
    end
    
    add_index :quotes, [:symbol, :date]
  end
  
  def self.down
    drop_table :quotes
  end
end
