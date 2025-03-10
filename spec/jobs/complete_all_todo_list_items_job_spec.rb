# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompleteAllTodoListItemsJob, type: :job do
  let!(:todo_list) { TodoList.create(name: 'Test list!') }
  let!(:other_todo_list) { TodoList.create(name: 'Other list!') }
  let!(:todo_list_item_1) { TodoListItem.create(todo_list: todo_list, name: 'Test item 1', completed: false) }
  let!(:todo_list_item_2) { TodoListItem.create(todo_list: todo_list, name: 'Test item 2', completed: true) }
  let!(:todo_list_item_3) { TodoListItem.create(todo_list: todo_list, name: 'Test item 3', completed: false) }
  let!(:other_todo_list_item) { TodoListItem.create(todo_list: other_todo_list, name: 'Other item', completed: false) }

  describe '#perform' do
    subject { described_class.perform_now(todo_list.id) }

    it 'completes all incomplete todo list items' do
      subject
      expect(todo_list.todo_list_items.incomplete).to be_empty
    end

    it 'does not complete todo list items from other lists' do
      subject
      expect(other_todo_list_item.reload.completed).to eq(false)
    end
  end
end
