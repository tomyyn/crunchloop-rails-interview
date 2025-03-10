# frozen_string_literal: true

class AddTodoListItems < ActiveRecord::Migration[7.0]
  def change
    create_table :todo_list_items do |t|
      t.string :name, null: false
      t.boolean :completed, default: false
      t.references :todo_list
    end
  end
end
