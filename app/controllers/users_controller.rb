class UsersController < ApplicationController

  # before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # before_action :correct_user,   only: [:edit, :update]
  # before_action :admin_user,     only: :destroy

  # def index
  #   @users = User.paginate(page: params[:page])
  # end

  # def show
  #   @user = User.find(params[:id])
  # end
    
  # def new
  #   @user = User.new
  # end

  # def create
  #   @user = User.new(user_params)
  #   if @user.save
  #     #log_in @user
  #     #flash[:success] = "Benvenuto!"
  #     #redirect_to @user
  #     @user.send_activation_email
  #     flash[:info] = "Controlla la tua email per attivare il tuo account."
  #     redirect_to root_url
  #   else
  #     render 'new'
  #   end
  # end

  # def edit
  #   @user = User.find(params[:id])
  # end

  # def update
  #   @user = User.find(params[:id])
  #   if @user.update_attributes(user_params)
  #     flash[:success] = "Profile updated"
  #     redirect_to @user
  #   else
  #     render 'edit'
  #   end
  # end

  # def destroy
  #   User.find(params[:id]).destroy
  #   flash[:success] = "User deleted"
  #   redirect_to users_url
  # end

  # def redirect
  #   client = Signet::OAuth2::Client.new(client_options)
  #   redirect_to client.authorization_uri.to_s
  # end

  # def callback
  #   client = Signet::OAuth2::Client.new(client_options)
  #   client.code = params[:code]
  #   response = client.fetch_access_token!
  #   session[:authorization] = response
  #   redirect_to calendars_url
  # end

  # def calendars
  #   client = Signet::OAuth2::Client.new(client_options)
  #   client.update!(session[:authorization])
  #   service = Google::Apis::CalendarV3::CalendarService.new
  #   service.authorization = client
  #   @calendar_list = service.list_calendar_lists
  #   render 'appointment'
  #   rescue Google::Apis::AuthorizationError
  #   response = client.refresh!

  #   session[:authorization] = session[:authorization].merge(response)

  #   retry
  # end


  # def events
  #   client = Signet::OAuth2::Client.new(client_options)
  #   client.update!(session[:authorization])

  #   service = Google::Apis::CalendarV3::CalendarService.new
  #   service.authorization = client

  #   @event_list = service.list_events(params[:calendar_id])
  #   render 'events'
  # end

  # def new_event
  #   client = Signet::OAuth2::Client.new(client_options)
  #   client.update!(session[:authorization])

  #   service = Google::Apis::CalendarV3::CalendarService.new
  #   service.authorization = client

  #   today = Date.today

  #   event = Google::Apis::CalendarV3::Event.new({
  #     start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
  #     end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
  #     summary: 'New event!'
  #   })

  #   service.insert_event(params[:calendar_id], event)

  #   redirect_to events_url(calendar_id: params[:calendar_id])
  # end

  # # def confirm
  # #   @user=User.new(user_params)
  # #   unless @user.valid?
  # #     render :new
  # #   end
  # # end




  # private

  #   def user_params
  #     params.require(:user).permit(:nome, :cognome, :codice_fiscale, :sesso, :data_nascita, 
  #                                   :nazione_nascita, :regione, :luogo_nascita, :nazione_residenza, 
  #                                   :regione_residenza, :citta_residenza, :indirizzo, 
  #                                   :email, :numero_telefono, 
  #                                   :password, :password_confirmation)
  #   end

  #   # Confirms a logged-in user.
  #   def logged_in_user
  #     unless logged_in?
  #       store_location
  #       flash[:danger] = "Please log in."
  #       redirect_to login_url
  #     end
  #   end

  #   # Confirms the correct user.
  #   def correct_user
  #     @user = User.find(params[:id])
  #     redirect_to(root_url) unless current_user?(@user)
  #   end

  #   # Confirms an admin user.
  #   def admin_user
  #     redirect_to(root_url) unless current_user.admin?
  #   end

  #   def client_options
  #   {
  #     client_id: Rails.application.secrets.google_client_id,
  #     client_secret: Rails.application.secrets.google_client_secret,
  #     authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
  #     token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
  #     scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
  #     redirect_uri: callback_url
  #   }
  # end
end
