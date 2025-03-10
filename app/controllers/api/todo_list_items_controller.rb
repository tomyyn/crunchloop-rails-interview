# frozen_string_literal: true

module Api
  class TodoListItemsController < BaseController
    before_action :set_todo_list
    before_action :set_todo_list_item, only: %i[show update destroy]

    # GET /api/todolists/:todo_list_id/todolist_items
    def index
      @todo_list_items = @todo_list.todo_list_items.all

      render :index
    end

    # POST /api/todolists/:todo_list_id/todolist_items
    def create
      @todo_list_item = TodoListItem.new(todo_list_item_params)

      if @todo_list_item.save
        render :show
      else
        render json: @todo_list_item.errors, status: :unprocessable_entity
      end
    end

    # PUT /api/todolists/:todo_list_id/todolist_items/:id
    def update
      if @todo_list_item.update(todo_list_item_params)
        render :show
      else
        render json: @todo_list_item.errors, status: :unprocessable_entity
      end
    end

    # GET /api/todolists/:todo_list_id/todolist_items/:id
    def show
      render :show
    end

    # DELETE /api/todolists/:todo_list_id/todolist_items/:id
    def destroy
      @todo_list_item.destroy
      head :no_content
    end

    private

    def set_todo_list
      @todo_list = TodoList.find_by(id: params[:todo_list_id])
      render json: { error: 'Todo list not found' }, status: :not_found unless @todo_list.present?
    end

    def set_todo_list_item
      @todo_list_item = @todo_list.todo_list_items.find_by(id: params[:id])
      render json: { error: 'Todo list item not found' }, status: :not_found unless @todo_list_item.present?
    end

    def todo_list_item_params
      params.permit(:name, :completed, :todo_list_id)
    end
  end
end
