class CreateDomainNameSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :domain_name_systems do |t|
      t.string :address, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
