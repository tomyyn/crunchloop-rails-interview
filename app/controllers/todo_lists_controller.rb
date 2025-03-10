# frozen_string_literal: true

class TodoListsController < ApplicationController
  before_action :set_todo_list, only: %i[show destroy complete_all]

  # GET /todolists
  def index
    @todo_lists = TodoList.all

    respond_to :html
  end

  # GET /todolists/new
  def new
    @todo_list = TodoList.new

    respond_to :html
  end

  # POST /todolists
  def create
    @todo_list = TodoList.new(todo_list_params)
    if @todo_list.save
      redirect_to todo_list_path(@todo_list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /todolists/:id
  def show
    respond_to :html
  end

  # DELETE /todolists/:id
  def destroy
    @todo_list.destroy
    redirect_to todo_lists_path, notice: 'Todo list was successfully deleted.'
  end

  # POST /todolists/:id/complete_all
  def complete_all
    CompleteAllTodoListItemsJob.perform_later(@todo_list.id)

    respond_to do |format|
      format.turbo_stream
      format.html { head :accepted }
    end
  end

  private

  def todo_list_params
    params.require(:todo_list).permit(:name)
  end

  def set_todo_list
    @todo_list = TodoList.find(params[:id])
  end
end
