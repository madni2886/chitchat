class AddRequestToMemberships < ActiveRecord::Migration[6.1]
  def change
    add_column :memberships, :req, :bool
  end
end
