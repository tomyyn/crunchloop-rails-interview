# frozen_string_literal: true

json.array! @todo_list_items, :id, :name, :todo_list_id, :completed
