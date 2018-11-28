class CreateHosts < ActiveRecord::Migration[5.2]
  def up
    create_table :hosts do |t|
      t.references :dns, foreign_key: { to_table: :domain_name_systems }, index: true
      t.string :name

      t.timestamps
    end

    add_index :hosts, :id
    add_index :hosts, [ :dns_id, :name ], unique: true
  end

  def down
    drop_table :hosts
  end
end
