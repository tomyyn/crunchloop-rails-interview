# frozen_string_literal: true

class TodoListItemsController < ApplicationController
  before_action :set_todo_list
  before_action :set_todo_list_item, only: %i[update destroy]

  # DELETE /todolists/:todo_list_id/todolist_items/:id
  def destroy
    @todo_list_item.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to todo_list_path(@todo_list), notice: 'Item deleted.' }
    end
  end

  def create
    @todo_list_item = @todo_list.todo_list_items.new(todo_list_item_params)

    if @todo_list_item.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to todo_list_path(@todo_list), notice: 'Item added.' }
      end
    else
      render json: { error: 'Could not create item' }, status: :unprocessable_entity
    end
  end

  def update
    p params
    if @todo_list_item.update(todo_list_item_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @todo_list }
      end
    else
      render json: { error: 'Failed to update item' }, status: :unprocessable_entity
    end
  end

  private

  def set_todo_list
    @todo_list = TodoList.find(params[:todo_list_id])
  end

  def set_todo_list_item
    @todo_list_item = @todo_list.todo_list_items.find(params[:id])
  end

  def todo_list_item_params
    params.require(:todo_list_item).permit(:name, :todo_list_id, :completed)
  end
end
