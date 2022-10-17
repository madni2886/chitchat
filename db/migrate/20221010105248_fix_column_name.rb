class FixColumnName < ActiveRecord::Migration[7.0]
  def self.up
    rename_column :comments, :content, :content
  end
  end

