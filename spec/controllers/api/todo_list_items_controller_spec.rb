# frozen_string_literal: true

require 'rails_helper'

describe Api::TodoListItemsController do
  render_views

  describe 'GET index' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }
    let!(:other_todo_list) { TodoList.create(name: 'No show') }
    let!(:todo_list_item_1) { TodoListItem.create(todo_list: todo_list, name: 'test2', completed: true) }
    let!(:todo_list_item_2) { TodoListItem.create(todo_list: todo_list, name: 'test2', completed: false) }
    let!(:todo_list_item_from_other_list) do
      TodoListItem.create(todo_list: other_todo_list, name: 'test2', completed: false)
    end

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect do
          get :index, params: { todo_list_id: todo_list.id }
        end.to raise_error(ActionController::RoutingError, 'JSON format required')
      end
    end

    context 'when format is JSON' do
      context 'with correct data' do
        it 'returns a success code' do
          get :index, format: :json, params: { todo_list_id: todo_list.id }

          expect(response.status).to eq(200)
        end

        it 'includes the desired todo list item records' do
          get :index, format: :json, params: { todo_list_id: todo_list.id }

          todo_list_items = JSON.parse(response.body)

          expect(todo_list_items.count).to eq(2)
          expect(todo_list_items[0].keys).to match_array(%w[id name todo_list_id completed])
          expect(todo_list_items[0]['id']).to eq(todo_list_item_1.id)
          expect(todo_list_items[0]['name']).to eq(todo_list_item_1.name)
          expect(todo_list_items[0]['todo_list_id']).to eq(todo_list_item_1.todo_list_id)
          expect(todo_list_items[0]['completed']).to eq(todo_list_item_1.completed)

          expect(todo_list_items[1].keys).to match_array(%w[id name todo_list_id completed])
          expect(todo_list_items[1]['id']).to eq(todo_list_item_2.id)
          expect(todo_list_items[1]['name']).to eq(todo_list_item_2.name)
          expect(todo_list_items[1]['todo_list_id']).to eq(todo_list_item_2.todo_list_id)
          expect(todo_list_items[1]['completed']).to eq(todo_list_item_2.completed)
        end

        it 'has the correct response schema' do
          get :index, format: :json, params: { todo_list_id: todo_list.id }

          expect(response).to match_response_schema('todoListItems')
        end
      end

      context 'with incorrect data' do
        context 'with a non-existent todo list' do
          it 'returns a not found status' do
            get :index, format: :json, params: { todo_list_id: 999 }

            expect(response.status).to eq(404)
          end
        end
      end
    end
  end

  describe 'POST create' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect do
          post :create, params: { todo_list_id: todo_list.id }
        end.to raise_error(ActionController::RoutingError, 'JSON format required')
      end
    end

    context 'when format is JSON' do
      context 'with correct data' do
        it 'returns a success code' do
          post :create, format: :json, params: { todo_list_id: todo_list.id, name: 'test1', completed: false }

          expect(response.status).to eq(200)
        end

        it 'creates a new todo list item' do
          expect do
            post :create, format: :json, params: { todo_list_id: todo_list.id, name: 'test1', completed: false }
          end.to change(TodoListItem, :count).by(1)
        end

        it 'includes the new todo list item record' do
          post :create, format: :json, params: { todo_list_id: todo_list.id, name: 'test1', completed: false }

          todo_list_item_response = JSON.parse(response.body)

          expect(todo_list_item_response.keys).to match_array(%w[id name todo_list_id completed])
          expect(todo_list_item_response['name']).to eq('test1')
          expect(todo_list_item_response['todo_list_id']).to eq(todo_list.id)
          expect(todo_list_item_response['completed']).to eq(false)
        end

        it 'has the correct response schema' do
          post :create, format: :json, params: { todo_list_id: todo_list.id, name: 'test1', completed: false }

          expect(response).to match_response_schema('todoListItem')
        end
      end

      context 'with incorrect data' do
        context 'with a non-existent todo list' do
          it 'returns a not found status' do
            post :create, format: :json, params: { todo_list_id: 999, name: 'test1', completed: false }

            expect(response.status).to eq(404)
          end
        end

        context 'without a name' do
          it 'returns an unprocessable entity status' do
            post :create, format: :json, params: { todo_list_id: todo_list.id, completed: false }

            expect(response.status).to eq(422)
          end

          it 'returns error messages' do
            post :create, format: :json, params: { todo_list_id: todo_list.id, completed: false }

            expect(JSON.parse(response.body)).to eq({ 'name' => ["can't be blank"] })
          end
        end
      end
    end
  end

  describe 'GET show' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }
    let!(:other_todo_list) { TodoList.create(name: 'No show') }
    let!(:todo_list_item) { TodoListItem.create(todo_list: todo_list, name: 'test2', completed: true) }
    let!(:todo_list_item_from_other_list) do
      TodoListItem.create(todo_list: other_todo_list, name: 'test2', completed: false)
    end

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect do
          get :show, params: { todo_list_id: todo_list.id, id: todo_list_item.id }
        end.to raise_error(ActionController::RoutingError, 'JSON format required')
      end
    end

    context 'when format is JSON' do
      context 'with correct data' do
        it 'returns a success code' do
          get :show, format: :json, params: { todo_list_id: todo_list.id, id: todo_list_item.id }

          expect(response.status).to eq(200)
        end

        it 'includes the desired todo list item record' do
          get :show, format: :json, params: { todo_list_id: todo_list.id, id: todo_list_item.id }

          todo_list_item_response = JSON.parse(response.body)

          expect(todo_list_item_response.keys).to match_array(%w[id name todo_list_id completed])
          expect(todo_list_item_response['id']).to eq(todo_list_item.id)
          expect(todo_list_item_response['name']).to eq(todo_list_item.name)
          expect(todo_list_item_response['todo_list_id']).to eq(todo_list_item.todo_list_id)
          expect(todo_list_item_response['completed']).to eq(todo_list_item.completed)
        end

        it 'has the correct response schema' do
          get :show, format: :json, params: { todo_list_id: todo_list.id, id: todo_list_item.id }

          expect(response).to match_response_schema('todoListItem')
        end
      end

      context 'with incorrect data' do
        context 'with a non-existent todo list' do
          it 'returns a not found status' do
            get :show, format: :json, params: { todo_list_id: 999, id: todo_list_item.id }

            expect(response.status).to eq(404)
          end
        end

        context 'with a non-existent todo list item' do
          it 'returns a not found status' do
            get :show, format: :json, params: { todo_list_id: todo_list.id, id: 999 }

            expect(response.status).to eq(404)
          end
        end

        context 'with a todo list item from another todo list' do
          it 'returns a not found status' do
            get :show, format: :json, params: { todo_list_id: todo_list.id, id: todo_list_item_from_other_list.id }

            expect(response.status).to eq(404)
          end
        end
      end
    end
  end

  describe 'PUT update' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }
    let!(:other_todo_list) { TodoList.create(name: 'No show') }
    let!(:todo_list_item) { TodoListItem.create(todo_list: todo_list, name: 'test2', completed: true) }
    let!(:todo_list_item_from_other_list) do
      TodoListItem.create(todo_list: other_todo_list, name: 'test2', completed: false)
    end

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect do
          put :update, params: { todo_list_id: todo_list.id, id: todo_list_item.id }
        end.to raise_error(ActionController::RoutingError, 'JSON format required')
      end
    end

    context 'when format is JSON' do
      context 'with correct data' do
        it 'returns a success code' do
          put :update, format: :json,
                       params: { todo_list_id: todo_list.id, id: todo_list_item.id, name: 'test3', completed: false }

          expect(response.status).to eq(200)
        end

        it 'updates the desired todo list item record' do
          put :update, format: :json,
                       params: { todo_list_id: todo_list.id, id: todo_list_item.id, name: 'test3', completed: false }

          todo_list_item.reload

          expect(todo_list_item.name).to eq('test3')
          expect(todo_list_item.completed).to eq(false)
        end

        it 'includes the updated todo list item record' do
          put :update, format: :json,
                       params: { todo_list_id: todo_list.id, id: todo_list_item.id, name: 'test3', completed: false }

          todo_list_item_response = JSON.parse(response.body)

          expect(todo_list_item_response.keys).to match_array(%w[id name todo_list_id completed])
          expect(todo_list_item_response['id']).to eq(todo_list_item.id)
          expect(todo_list_item_response['name']).to eq('test3')
          expect(todo_list_item_response['todo_list_id']).to eq(todo_list_item.todo_list_id)
          expect(todo_list_item_response['completed']).to eq(false)
        end

        it 'has the correct response schema' do
          put :update, format: :json,
                       params: { todo_list_id: todo_list.id, id: todo_list_item.id, name: 'test3', completed: false }

          expect(response).to match_response_schema('todoListItem')
        end
      end

      context 'with incorrect data' do
        context 'with a non-existent todo list' do
          it 'returns a not found status' do
            put :update, format: :json,
                         params: { todo_list_id: 999, id: todo_list_item.id, name: 'test3', completed: false }

            expect(response.status).to eq(404)
          end
        end

        context 'with a non-existent todo list item' do
          it 'returns a not found status' do
            put :update, format: :json, params: { todo_list_id: todo_list.id, id: 999, name: 'test3', completed: false }

            expect(response.status).to eq(404)
          end
        end

        context 'with a todo list item from another todo list' do
          it 'returns a not found status' do
            put :update, format: :json,
                         params: { todo_list_id: todo_list.id, id: todo_list_item_from_other_list.id, name: 'test3', completed: false }

            expect(response.status).to eq(404)
          end
        end

        context 'with a nil name' do
          it 'returns an unprocessable entity status' do
            put :update, format: :json,
                         params: { todo_list_id: todo_list.id, id: todo_list_item.id, name: nil, completed: false }

            expect(response.status).to eq(422)
          end
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }
    let!(:other_todo_list) { TodoList.create(name: 'No show') }
    let!(:todo_list_item) { TodoListItem.create(todo_list: todo_list, name: 'test2', completed: true) }
    let!(:todo_list_item_from_other_list) do
      TodoListItem.create(todo_list: other_todo_list, name: 'test2', completed: false)
    end

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect do
          delete :destroy, params: { todo_list_id: todo_list.id, id: todo_list_item.id }
        end.to raise_error(ActionController::RoutingError, 'JSON format required')
      end
    end

    context 'when format is JSON' do
      context 'with correct data' do
        it 'returns a no content status' do
          delete :destroy, format: :json, params: { todo_list_id: todo_list.id, id: todo_list_item.id }

          expect(response.status).to eq(204)
        end

        it 'deletes the desired todo list item record' do
          expect do
            delete :destroy, format: :json, params: { todo_list_id: todo_list.id, id: todo_list_item.id }
          end.to change(TodoListItem, :count).by(-1)
        end
      end

      context 'with incorrect data' do
        context 'with a non-existent todo list' do
          it 'returns a not found status' do
            delete :destroy, format: :json, params: { todo_list_id: 999, id: todo_list_item.id }

            expect(response.status).to eq(404)
          end
        end

        context 'with a non-existent todo list item' do
          it 'returns a not found status' do
            delete :destroy, format: :json, params: { todo_list_id: todo_list.id, id: 999 }

            expect(response.status).to eq(404)
          end
        end

        context 'with a todo list item from another todo list' do
          it 'returns a not found status' do
            delete :destroy, format: :json,
                             params: { todo_list_id: todo_list.id, id: todo_list_item_from_other_list.id }

            expect(response.status).to eq(404)
          end
        end
      end
    end
  end
end
