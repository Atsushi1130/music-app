Rails.application.routes.draw do
  get '/search' => "search#search"
  post '/search/:trackId/:collectionId/:artistName/:collectionName/:trackName' => "search#new"
  get "/" => "search#init"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
