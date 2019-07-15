Jets.application.routes.draw do
  root "jets/public#show"

  get  "models/:type/:stage",      to: "models#list"
  get  "models_form/:type/:stage", to: "models#form"
  get  "build_id/:name",           to: "projects#build_id"
  any "*catchall",                 to: "jets/public#show"
end
