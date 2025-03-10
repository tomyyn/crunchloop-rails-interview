# frozen_string_literal: true

module Api
  class TodoListsController < BaseController
    before_action :set_todo_list, only: %i[show update destroy]

    # GET /api/todolists
    def index
      @todo_lists = TodoList.all

      render :index
    end

    # POST /api/todolists
    def create
      @todo_list = TodoList.new(todo_list_params)

      if @todo_list.save
        render :show
      else
        render json: @todo_list.errors, status: :unprocessable_entity
      end
    end

    # PUT /api/todolists/:id
    def update
      if @todo_list.update(todo_list_params)
        render :show
      else
        render json: @todo_list.errors, status: :unprocessable_entity
      end
    end

    # GET /api/todolists/:id
    def show
      render :show
    end

    # DELETE /api/todolists/:id
    def destroy
      @todo_list.destroy
      head :no_content
    end

    private

    def set_todo_list
      @todo_list = TodoList.find_by(id: params[:id])
      render json: { error: 'Todo list not found' }, status: :not_found unless @todo_list.present?
    end

    def todo_list_params
      params.permit(:name)
    end
  end
end
