# frozen_string_literal: true

class TodoListItem < ApplicationRecord
  belongs_to :todo_list, optional: false

  after_update_commit lambda {
    broadcast_replace_to "todo_list_#{todo_list.id}"
  }

  validates :name, presence: true

  scope :incomplete, -> { where(completed: false) }
end
