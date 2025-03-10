# frozen_string_literal: true

require 'rails_helper'

describe Api::TodoListsController do
  render_views

  describe 'GET index' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect do
          get :index
        end.to raise_error(ActionController::RoutingError, 'JSON format required')
      end
    end

    context 'when format is JSON' do
      context 'with correct data' do
        it 'returns a success code' do
          get :index, format: :json

          expect(response.status).to eq(200)
        end

        it 'includes todo list records' do
          get :index, format: :json

          todo_lists = JSON.parse(response.body)

          expect(todo_lists.count).to eq(1)
          expect(todo_lists[0].keys).to match_array(%w[id name])
          expect(todo_lists[0]['id']).to eq(todo_list.id)
          expect(todo_lists[0]['name']).to eq(todo_list.name)
        end

        it 'has the correct response schema' do
          get :index, format: :json

          expect(response).to match_response_schema('todoLists')
        end
      end
    end
  end

  describe 'POST create' do
    context 'when format is HTML' do
      it 'raises a routing error' do
        expect do
          post :create
        end.to raise_error(ActionController::RoutingError, 'JSON format required')
      end
    end

    context 'when format is JSON' do
      context 'with correct data' do
        it 'returns a success code' do
          post :create, params: { name: 'Setup RoR project' }, format: :json

          expect(response.status).to eq(200)
        end

        it 'creates a new todo list record' do
          expect do
            post :create, params: { name: 'Setup RoR project' }, format: :json
          end.to change(TodoList, :count).by(1)
        end

        it 'includes the new todo list record' do
          post :create, params: { name: 'Setup RoR project' }, format: :json

          todo_list = JSON.parse(response.body)

          expect(todo_list.keys).to match_array(%w[id name])
          expect(todo_list['name']).to eq('Setup RoR project')
        end

        it 'has the correct response schema' do
          post :create, params: { name: 'Setup RoR project' }, format: :json

          expect(response).to match_response_schema('todoList')
        end
      end

      context 'with incorrect data' do
        context 'when name is missing' do
          it 'returns an unprocessable entity status' do
            post :create, params: { name: nil }, format: :json

            expect(response.status).to eq(422)
          end

          it 'returns an error message' do
            post :create, params: { name: nil }, format: :json

            error_message = JSON.parse(response.body)

            expect(error_message['name']).to include("can't be blank")
          end
        end
      end
    end
  end

  describe 'GET show' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect do
          get :show, params: { id: todo_list.id }
        end.to raise_error(ActionController::RoutingError, 'JSON format required')
      end
    end

    context 'when format is JSON' do
      context 'with correct data' do
        it 'returns a success code' do
          get :show, params: { id: todo_list.id }, format: :json

          expect(response.status).to eq(200)
        end

        it 'includes the todo list record' do
          get :show, params: { id: todo_list.id }, format: :json

          todo_list_response = JSON.parse(response.body)

          expect(todo_list_response.keys).to match_array(%w[id name])
          expect(todo_list_response['id']).to eq(todo_list.id)
          expect(todo_list_response['name']).to eq(todo_list.name)
        end

        it 'has the correct response schema' do
          get :show, params: { id: todo_list.id }, format: :json

          expect(response).to match_response_schema('todoList')
        end
      end

      context 'with incorrect data' do
        context 'when todo list does not exist' do
          it 'returns a not found status' do
            get :show, params: { id: 0 }, format: :json

            expect(response.status).to eq(404)
          end
        end
      end
    end
  end

  describe 'PUT update' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect do
          put :update, params: { id: todo_list.id }
        end.to raise_error(ActionController::RoutingError, 'JSON format required')
      end
    end

    context 'when format is JSON' do
      context 'with correct data' do
        it 'returns a success code' do
          put :update, params: { id: todo_list.id, name: 'Setup Rails project' }, format: :json

          expect(response.status).to eq(200)
        end

        it 'updates the todo list record' do
          put :update, params: { id: todo_list.id, name: 'Setup Rails project' }, format: :json

          todo_list.reload

          expect(todo_list.name).to eq('Setup Rails project')
        end

        it 'includes the updated todo list record' do
          put :update, params: { id: todo_list.id, name: 'Setup Rails project' }, format: :json

          todo_list_response = JSON.parse(response.body)

          expect(todo_list_response.keys).to match_array(%w[id name])
          expect(todo_list_response['id']).to eq(todo_list.id)
          expect(todo_list_response['name']).to eq('Setup Rails project')
        end

        it 'has the correct response schema' do
          put :update, params: { id: todo_list.id, name: 'Setup Rails project' }, format: :json

          expect(response).to match_response_schema('todoList')
        end
      end

      context 'with incorrect data' do
        context 'without a name' do
          it 'returns an unprocessable entity status' do
            put :update, params: { id: todo_list.id, name: nil }, format: :json

            expect(response.status).to eq(422)
          end

          it 'returns an error message' do
            put :update, params: { id: todo_list.id, name: nil }, format: :json

            error_message = JSON.parse(response.body)

            expect(error_message['name']).to include("can't be blank")
          end
        end

        context 'when todo list does not exist' do
          it 'returns a not found status' do
            put :update, params: { id: 0, name: 'Setup Rails project' }, format: :json

            expect(response.status).to eq(404)
          end
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect do
          delete :destroy, params: { id: todo_list.id }
        end.to raise_error(ActionController::RoutingError, 'JSON format required')
      end
    end

    context 'when format is JSON' do
      context 'with correct data' do
        it 'returns a no content status' do
          delete :destroy, params: { id: todo_list.id }, format: :json

          expect(response.status).to eq(204)
        end

        it 'deletes the todo list record' do
          expect do
            delete :destroy, params: { id: todo_list.id }, format: :json
          end.to change(TodoList, :count).by(-1)
        end
      end

      context 'with incorrect data' do
        context 'when todo list does not exist' do
          it 'returns a not found status' do
            delete :destroy, params: { id: 0 }, format: :json

            expect(response.status).to eq(404)
          end
        end
      end
    end
  end
end
