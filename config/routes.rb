# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :todo_lists, only: %i[index create show update destroy], path: :todolists do
      resources :todo_list_items, only: %i[index create show update destroy], path: :todolist_items
    end
  end

  resources :todo_lists, only: %i[index new create show destroy], path: :todolists do
    member do
      patch :complete_all
    end
    resources :todo_list_items, only: %i[destroy create update], path: :todolist_items
  end

  mount ActionCable.server => '/cable'
end
