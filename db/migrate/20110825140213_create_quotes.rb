class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.string     :symbol
      t.string     :name
      t.decimal    :price,    :scale => 2, :precision => 10
      t.datetime   :date
      t.decimal    :low,  :scale => 2, :precision => 10
      t.decimal    :high, :scale => 2, :precision => 10
      t.decimal    :open,     :scale => 2, :precision => 10
      t.decimal    :close,    :scale => 2, :precision => 10
      t.decimal    :ask,      :scale => 2, :precision => 10
      t.decimal    :bid,      :scale => 2, :precision => 10
      t.decimal    :bid_size, :scale => 2, :precision => 10
      t.integer    :volume
      t.integer    :average_daily_volume
      
      t.timestamps
    end
    
    add_index :quotes, [:symbol, :date], unique: true
  end
  
  def self.down
    drop_table :quotes
  end
end
