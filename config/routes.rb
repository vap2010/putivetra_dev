Putivetra::Application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => "articles#index"

  Brand.find(:all).each do |b|
    match  b.title.downcase.to_s                  => 'brand#index'
    match  b.title.downcase.to_s + '/:id'         => 'brand#category'
    match  b.title.downcase.to_s + '/:id/:series' => 'brand#series'
    match  b.title.downcase.to_s + '/:id/:series/:block' => 'brand#block'
  end

  match  'novosti'     => 'articles#novosti_index', :as => :novosti_index
  match  'novosti/:id' => 'articles#novosti',       :as => :novosti

  match  'rabota'     => 'articles#rabota_index', :as => :rabota_index
  match  'rabota/:id' => 'articles#rabota',       :as => :rabota

  match  'nashi_proekty'     => 'articles#nashi_proekty_index', :as => :nashi_proekty_index
  match  'nashi_proekty/:id' => 'articles#nashi_proekty',       :as => :nashi_proekty

  match  'otzivi'     => 'articles#otzivi_index', :as => :otzivi_index
  match  'otzivi/:id' => 'articles#otzivi',       :as => :otzivi

  match  'nagrady'     => 'articles#nagrady_index', :as => :nagrady_index
  match  'nagrady/:id' => 'articles#nagrady',       :as => :nagrady

  match  'akcii'     => 'articles#akcii_index', :as => :akcii_index
  match  'akcii/:id' => 'articles#akcii',       :as => :akcii

  match  'slovar'             => 'articles#slovar_index',  :as => :slovar_index
  match  'slovar/:id'         => 'articles#slovar',        :as => :slovar_lang
  match  'slovar/:id/:letter' => 'articles#slovar_letter', :as => :slovar_letter
  match  'slovar/:id/:letter/:word' => 'articles#slovar_word', :as => :slovar_word

   match ':id',           :to => "articles#show"
   match ':id/:series'        => 'brand#series'
   match ':id/:series/:block' => 'brand#block'

  ###################################################
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'

  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
