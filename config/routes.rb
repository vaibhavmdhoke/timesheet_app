Rails.application.routes.draw do
  resources :timesheet_entries
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'timesheet_entries#index'
end
