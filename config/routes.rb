Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'start', to: 'file#start'
  post 'sendtoworker', to: 'file#send_to_worker'
end
