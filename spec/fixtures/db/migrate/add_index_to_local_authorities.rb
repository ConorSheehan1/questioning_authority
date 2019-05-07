class AddIndexToLocalAuthorities < ActiveRecord::Migration[5.2]
  def change
    add_index :local_authority_entries,
              ['local_authority_id', 'lower(label)'],
              name: 'index_local_authority_entries_on_lower_label',
              unique: true
  end
end