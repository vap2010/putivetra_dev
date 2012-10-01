Putivetra::Application.routes.draw do

  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => "articles#index"

  Brand.find(:all).each do |b|
    burl = b.meta_tag.url.downcase.to_s
    match  burl + '.html'            => 'brands#brand_index',  :brand => "#{b.id}", :as => "#{burl}_index".to_sym
    match  burl + '/:cat.html'       => 'brands#brand_category',  :brand => "#{b.id}",  :as => "#{burl}_category".to_sym
    match  burl + '/:cat/:subcat.html'  => 'brands#brand_subcategory',  :brand => "#{b.id}", :as => "#{burl}_subcategory".to_sym
    match  burl + '/:cat/:subcat/:series.html'  => 'brands#brand_series',  :brand => "#{b.id}", :as => "#{burl}_series".to_sym
    match  burl + '/:cat/:subcat/:series/:block.html'  => 'brands#brand_block',  :brand => "#{b.id}", :as => "#{burl}_block".to_sym
  end

  get  'novosti.html'     => 'articles#novosti_index', :as => :novosti_index
  match  'novosti/:id.html' => 'articles#novosti',     :as => :novosti

  get  'rabota.html'     => 'articles#rabota_index', :as => :rabota_index
  match  'rabota/:id.html' => 'articles#rabota',     :as => :rabota

  get  'nashi_proekty.html'     => 'articles#nashi_proekty_index', :as => :nashi_proekty_index
  match  'nashi_proekty/:id.html' => 'articles#nashi_proekty',     :as => :nashi_proekty

  get  'otzivi.html'     => 'articles#otzivi_index', :as => :otzivi_index
  match  'otzivi/:id.html' => 'articles#otzivi',     :as => :otzivi

  get  'nagrady.html'     => 'articles#nagrady_index', :as => :nagrady_index
  match  'nagrady/:id.html' => 'articles#nagrady',     :as => :nagrady

  get  'akcii.html'     => 'articles#akcii_index', :as => :akcii_index
  match  'akcii/:id.html' => 'articles#akcii',     :as => :akcii

  get  'slovar.html'             => 'dictionaries#slovar_index',  :as => :slovar_index
  match  'slovar/:id.html'           => 'dictionaries#slovar',    :as => :slovar_lang
  match  'slovar/:id/:letter.html'       => 'dictionaries#slovar_letter', :as => :slovar_letter
  match  'slovar/:id/:letter/:word.html' => 'dictionaries#slovar_word',   :as => :slovar_word

  match ':id.html',         :to => "brands#page",    :as => :page
  match ':id/:subcat.html', :to => "brands#subpage", :as => :subpage

 # match ':id/:series'        => 'brands#series'
 # match ':id/:series/:block' => 'brands#block'

# articles  index  novosti_index novosti  rabota_index rabota  nashi_proekty_index nashi_proekty
#           otzivi_index otzivi  nagrady_index nagrady  akcii_index akcii
# dictionaries  slovar_index slovar  slovar_letter  slovar_word
# brands  page subpage brand_index brand_category brand_subcategory brand_series brand_block

     
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
