# frozen_string_literal: true

TodoList.create(name: 'Setup Rails Application')
TodoList.create(name: 'Setup Docker PG database')
TodoList.create(name: 'Create todo_lists table')
TodoList.create(name: 'Create TodoList model')
TodoList.create(name: 'Create TodoList controller')

TodoListItem.create(name: 'Create TodoListItems table', todo_list: TodoList.first)
TodoListItem.create(name: 'Create TodoListItem model', todo_list: TodoList.first)
TodoListItem.create(name: 'Create TodoListItem controller', todo_list: TodoList.first)
TodoListItem.create(name: 'Create TodoListItem views', todo_list: TodoList.first)
