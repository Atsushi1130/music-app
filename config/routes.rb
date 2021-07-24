Rails.application.routes.draw do
  root "search#init"
  # searchコントローラ
  get "/test" => "search#test"
  get '/search' => "search#search"
  post '/search/:trackId/:collectionId/:artistName/:collectionName/:trackName' => "search#new"
  get '/search/:trackId/delete' => "search#delete"
  get "/" => "search#init"

  # userコントローラ
  get "/signup" => "user#new"
  post "/users/create" => "user#create"
  get "/login_form" => "user#login_form"
  post "/login" => "user#login"
  post "/logout" => "user#logout"
  get "/user/:id/show" => "user#show"
  get "/user/:id/edit" => "user#edit"
  post "/user/:id/update" => "user#update"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
