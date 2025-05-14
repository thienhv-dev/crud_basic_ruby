# frozen_string_literal: true

devise_for :users,
           class_name: 'User::Entities::User',
           controllers: { auth: 'auth/http/controllers/auth' }

# Define the API versioning
scope 'api/v1', as: 'api_v1', module: 'auth/http/controllers' do
  devise_scope :user do
    post 'login', to: 'auth#create'
    delete 'logout', to: 'auth#destroy'
  end

  get 'me', to: 'profile#show'
end