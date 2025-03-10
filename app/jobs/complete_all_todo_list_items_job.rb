# frozen_string_literal: true

class CompleteAllTodoListItemsJob < ApplicationJob
  queue_as :default

  def perform(todo_list_id)
    todo_list = TodoList.find(todo_list_id)
    todo_list.todo_list_items.incomplete.find_each { |todo_item| todo_item.update(completed: true) }
  end
end
