# modules/category/routes/api.rb

scope 'api/v1' do
  scope 'categories', module: 'category/http/controllers' do
    get '', to: 'category#index'
    get ':id', to: 'category#show'
    post '', to: 'category#store'
    put ':id', to: 'category#update'
    delete '/:id', to: 'category#destroy'
  end
end