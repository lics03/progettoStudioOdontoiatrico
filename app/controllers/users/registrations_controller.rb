# frozen_string_literal: true
require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]


  # before_action :authenticate_user!
  # before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # before_action :correct_user,   only: [:edit, :update]
  # before_action :admin_user,     only: :destroy

  CALENDAR_ID = "progettoarchitetture@gmail.com"

  def index
    if current_user.is_doctor
      @users = User.paginate(page: params[:page], per_page: 20)
    else
      flash[:error] = "Sorry you can't access this page"
      redirect_to current_user
    end
  end

  def show
    if user_signed_in?
      if params[:id].to_i == current_user.id || current_user.is_doctor
        @user = User.find(params[:id])
      else
        flash[:info] = "Sorry you can't access this"
        redirect_to current_user
      end
    else
      flash[:error] = "You must login first"
      redirect_to root_url
    end
  end
    
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Controlla la tua email per attivare il tuo account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def add_data
    @user = User.find_by_email(params[:email])
    if request.get?
      render 'oauth_add_data'
    elsif request.put? && (@user.update_with_password(user_params) || @user.update_attributes(user_params))
        flash[:success] = "Sign up process successful"
        bypass_sign_in(@user)
        redirect_to root_url
    end
  end

  def update
    if current_user.id.to_s == params[:id].to_s
      if current_user.update_with_password(user_params) || current_user.update_attributes(user_params)
        flash[:success] = "Profile updated"
        bypass_sign_in(current_user)
        redirect_to current_user
      else
        render 'edit'
      end
    end
  end

  def calendar_options
    cal = Google::Apis::CalendarV3::CalendarService.new
    cal.authorization = google_secret.to_authorization
    cal.authorization.refresh!
    cal
  end

  def calendars
    @calendar = calendar_options.list_calendar_lists.items[0]
    render 'appointment'
  end


  def events
    @event_list = calendar_options.list_events(CALENDAR_ID)
    render 'events'
  end

  def new_event
    if params[:events][:summary] == "Controllo" || params[:events][:summary] == "Visita" || params[:events][:summary] == "Operazione"
      event = Google::Apis::CalendarV3::Event.new({
        start: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: DateTime.parse(params[:events][:start_date] + " " + params[:events][:start_time]).change(offset:'+0200'),
        ),
        end: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: DateTime.parse(params[:events][:end_date] + " " + params[:events][:end_time]).change(offset:'+0200'),
        ),
        summary: params[:events][:summary]
      })
      calendar_options.insert_event(CALENDAR_ID, event)

      redirect_to events_url
    else
      flash[:error] = "Sorry this is not a valid option"
      redirect_to events_url
    end
  end

  def delete_event
    event_id = params[:events][:events]
    calendar_options.delete_event(CALENDAR_ID, event_id)
    flash[:success] = "The event with id " + event_id.to_s + " has been cancelled"
    redirect_to events_url
  end

  # def confirm
  #   @user=User.new(user_params)
  #   unless @user.valid?
  #     render :new
  #   end
  # end

  private

    def user_params
      params.require(:user).permit(:nome, :cognome, :codice_fiscale, :sesso, :data_nascita, 
                                    :nazione_nascita, :regione, :luogo_nascita, :nazione_residenza, 
                                    :regione_residenza, :citta_residenza, :indirizzo, 
                                    :email, :current_password, :numero_telefono, 
                                    :password, :password_confirmation)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless user_signed_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = current_user
      redirect_to(root_url) unless current_user
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end


    # def authenticate_user!
    #   if user_signed_in?
    #     super
    #   else
    #     redirect_to new_user_session_path, :notice => 'You have to login before accessing this'
    #     ## if you want render 404 page
    #     ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    #   end
    # end
    # def client_options
    # {
    #   client_id: Rails.application.secrets.google_client_id,
    #   client_secret: Rails.application.secrets.google_client_secret,
    #   authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
    #   token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
    #   scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
    #   redirect_uri: users_callback_url
    # }
    # end

    def google_secret
      # puts current_user.access_token
      # puts current_user.refresh_token #For the user Lupo Lucio, that is the one that we are interested in
      Google::APIClient::ClientSecrets.new(
        { "web" =>
          {
            "access_token" => "ya29.GltgB83Y-mQjjdIj1Is8davcoRYaRg4mkAlBp5-sj8NHiuWZTEtIQOPZFNRzRk-zcu8jqcc_pRXXcoSJekHk6upts8t0lRV1GjDabp0nNLbQhfYlbqmZEFiJUNfV",
            "refresh_token" => "1/NivxsXTyZmkl3zDKTzkPBh_uAiLuLu9Lv8l1-XvBk9U",
            "client_id" => Rails.application.secrets.google_client_id,
            "client_secret" => Rails.application.secrets.google_client_secret,
          }
        }
      )
    end



      # def destroy
      #   User.find(params[:id]).destroy
      #   flash[:success] = "User deleted"
      #   redirect_to users_url
      # end
    # def calendars
  #   if current_user.provider == "google_oauth2" || session[:authorization] != nil
  #     if session[:authorization]
  #       client = Signet::OAuth2::Client.new(client_options)
  #       client.update!(session[:authorization])
  #       service = Google::Apis::CalendarV3::CalendarService.new
  #       service.authorization = client
  #       service.authorization.access_token = "ya29.GltfB5bGsdxRpSwclB2DK2SXhgK0Y8mkT0OWfBKjdX2SckQV6UmXD403KemiqowDdIQVk4Y6LEOOskJAY3lsLTBI0QkpqzpEcojPhtV-1Kq6Vp2p9T0FDtaqQtw7"
  #       service.authorization.refresh_token = "1/ds8u3PIHAvu-LO853_O5tuZOaZ9vykf6aBuz0jJjHXk"
  #       @calendar_list = service.list_calendar_lists
  #     else
  #       cal = Google::Apis::CalendarV3::CalendarService.new
  #       cal.authorization = google_secret.to_authorization
  #       cal.authorization.refresh!
  #       @calendar = cal.list_calendar_lists.items[0]
  #       render 'appointment'
  #     end
  #   # rescue Google::Apis::AuthorizationError
  #   #   response = client.refresh!

  #   #   session[:authorization] = session[:authorization].merge(response)
  #   #   retry
  #   else
  #     client = Signet::OAuth2::Client.new(client_options)
  #     redirect_to client.authorization_uri.to_s
  #   end
  # end

  # def events
  #   if session[:authorization]
  #     client = Signet::OAuth2::Client.new(client_options)
  #     client.update!(session[:authorization])

  #     service = Google::Apis::CalendarV3::CalendarService.new
  #     service.authorization = client
  #     service.authorization.access_token = "ya29.GltfB5bGsdxRpSwclB2DK2SXhgK0Y8mkT0OWfBKjdX2SckQV6UmXD403KemiqowDdIQVk4Y6LEOOskJAY3lsLTBI0QkpqzpEcojPhtV-1Kq6Vp2p9T0FDtaqQtw7"
  #     service.authorization.refresh_token = "1/ds8u3PIHAvu-LO853_O5tuZOaZ9vykf6aBuz0jJjHXk"
  #     @event_list = service.list_events(CALENDAR_ID)
  #   else
  #     cal = Google::Apis::CalendarV3::CalendarService.new
  #     cal.authorization = google_secret.to_authorization
  #     cal.authorization.refresh!
  #     @event_list = cal.list_events(CALENDAR_ID)
  #   end
  #   render 'events'
  # end

  # def new_event
  #   # client = Signet::OAuth2::Client.new(client_options)
  #   # client.update!(session[:authorization])

  #   # service = Google::Apis::CalendarV3::CalendarService.new
  #   # service.authorization = client
  #   # service.authorization.access_token = "ya29.GltfB5bGsdxRpSwclB2DK2SXhgK0Y8mkT0OWfBKjdX2SckQV6UmXD403KemiqowDdIQVk4Y6LEOOskJAY3lsLTBI0QkpqzpEcojPhtV-1Kq6Vp2p9T0FDtaqQtw7"
  #   # service.authorization.refresh_token = "1/ds8u3PIHAvu-LO853_O5tuZOaZ9vykf6aBuz0jJjHXk"

  #   today = Date.today
  #   event = Google::Apis::CalendarV3::Event.new({
  #     start: Google::Apis::CalendarV3::EventDateTime.new(date: Date.parse(params[:events][:start])),
  #     end: Google::Apis::CalendarV3::EventDateTime.new(date: Date.parse(params[:events][:end])),
  #     summary: params[:events][:summary]
  #   })
  #   # event = Google::Apis::CalendarV3::Event.new({
  #   #   start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
  #   #   end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
  #   #   summary: 'New event!'
  #   # })

  #   calendar_options.insert_event(CALENDAR_ID, event)

  #   redirect_to events_url(calendar_id: CALENDAR_ID)
  # end

  # def confirm
  #   @user=User.new(user_params)
  #   unless @user.valid?
  #     render :new
  #   end
  # end


  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
