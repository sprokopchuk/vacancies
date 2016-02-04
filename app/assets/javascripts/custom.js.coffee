$(document).on 'ready page:load', ->
  CountryStateSelect({ chosen_ui: true, country_id: "vacancy_search_country", state_id: "vacancy_search_state", city_id: "vacancy_search_city" })