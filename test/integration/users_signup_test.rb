require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { nome:  "", cognome: "", codice_fiscale:"", sesso:"F", 
        data_nascita:"", nazione_nascita:"", luogo_nascita:"", 
        nazione_residenza:"", citta_residenza:"", indirizzo:"", 
        email: "jessica@example", numero_telefono:"3", 
        password: "a", password_confirmation: "aaa"}
    end
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { nome: "Jessica", cognome:"Brandi", 
        codice_fiscale:"BRNJSC94P68H501D", sesso:"F", data_nascita:"28/09/94", 
        nazione_nascita:"Italia", luogo_nascita:"Roma", nazione_residenza:"Italia", 
        citta_residenza:"Roma", indirizzo:"Via Roma", email: "jessica@example.com", 
        numero_telefono:"3333333333", password: "aaaaaa", password_confirmation: "aaaaaa" }
    end
    assert_template 'users/show'
    assert is_logged_in?
  end
end