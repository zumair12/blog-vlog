# frozen_string_literal: true

Rails.application.routes.draw do
  # ─── Public / Reader routes ───────────────────────────────────────────────
  root "posts#index"

  resources :posts, only: %i[index show], param: :slug do
    resources :comments, only: %i[create destroy]
  end

  resources :categories, only: %i[index show], param: :slug
  resources :tags, only: %i[index show], param: :slug

  # Search
  get "/search", to: "search#index", as: :search

  # Archive
  get "/archive", to: "posts#archive", as: :archive

  # ─── Authentication ────────────────────────────────────────────────────────
  devise_for :users, path: "auth", path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "register"
  }

  # User profiles
  resources :users, only: %i[show], param: :username

  # ─── Admin namespace ───────────────────────────────────────────────────────
  namespace :admin do
    root "dashboard#index"

    resources :posts do
      member do
        patch :publish
        patch :archive
        patch :feature
        patch :unfeature
      end
    end

    resources :categories
    resources :tags

    resources :comments, only: %i[index show update destroy] do
      member do
        patch :approve
        patch :reject
        patch :mark_spam
      end
      collection do
        patch :bulk_approve
        patch :bulk_reject
      end
    end

    resources :users, only: %i[index show edit update] do
      member do
        patch :change_role
        patch :ban
        patch :unban
      end
    end

    get "analytics", to: "dashboard#analytics", as: :analytics
  end

  # PWA routes
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
