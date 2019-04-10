require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

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

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user:  { nome: "Jessica", cognome:"Brandi", 
        codice_fiscale:"BRNJSC94P68H501D", sesso:"F", data_nascita:"28/09/94", 
        nazione_nascita:"Italia", luogo_nascita:"Roma", nazione_residenza:"Italia", 
        citta_residenza:"Roma", indirizzo:"Via Roma", email: "jessica@example.com", 
        numero_telefono:"3333333333", password: "aaaaaa", password_confirmation: "aaaaaa" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?

    
    #assert_template 'users/show'
    #assert is_logged_in?
  end
end