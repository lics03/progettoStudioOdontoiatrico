document.addEventListener("turbolinks:load", function(){
  var country = document.getElementById("user_nazione_nascita");
  var state = document.getElementById("user_regione");
  var country_res = document.getElementById("user_nazione_residenza");
  var state_res = document.getElementById("user_regione_residenza");

  country.addEventListener("change", function(){
    Rails.ajax({
      url: "/signup?country=" + country.value + "&id=user_regione",
      type: "POST"
    })
  })

  state.addEventListener("change", function(){
    Rails.ajax({
      url: "/signup?country=" + country.value + "&state=" + state.value + "&id=user_luogo_nascita",
      type: "POST"
    })
  })

  country_res.addEventListener("change", function(){
    Rails.ajax({
      url: "/signup?country=" + country_res.value + "&id=user_regione_residenza",
      type: "POST"
    })
  })

  state_res.addEventListener("change", function(){
    Rails.ajax({
      url: "/signup?country=" + country_res.value + "&state=" + state_res.value + "&id=user_citta_residenza",
      type: "POST"
    })
  })
})
