Calamp::Application.routes.draw do
  get "/logs", :to => "logs#index", :as => "logs"
  root :to => "welcome#index"
end
