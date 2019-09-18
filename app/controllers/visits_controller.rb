require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'

class VisitsController < ApplicationController

  CALENDAR_ID = "progettoarchitetture@gmail.com"


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

  def calendar
    render 'visits'
  end

  def show
    @visits_list = current_user.visits
    puts(@visit_list)
  end

  def new
    @visit = Visit.new
    @visit_list = calendar_options.list_events(CALENDAR_ID)
    render 'add_visit'
  end

  def create
    # puts "**************************"
    # puts params[:visits]
    # puts "**************************"
    if params[:visits][:tipo] == "Controllo" || params[:visits][:tipo] == "Visita" || params[:visits][:tipo] == "Operazione"
      visit = Google::Apis::CalendarV3::Event.new({
        start: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: DateTime.parse(params[:visits][:data_inizio] + " " + params[:visits][:ora_inizio]).change(offset:'+0200'),
        ),
        end: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: DateTime.parse(params[:visits][:data_fine] + " " + params[:visits][:ora_fine]).change(offset:'+0200'),
        ),
        summary: current_user.is_doctor? ? params[:visits][:paziente] + " - " + params[:visits][:tipo] + 
                    " - Giorno: " + params[:visits][:data_inizio] + " - Ora: " + params[:visits][:ora_inizio] : 
                    current_user.nome + " " + current_user.cognome + " - " + params[:visits][:tipo] + 
                    " - Giorno: " + params[:visits][:data_inizio] + " - Ora: " + params[:visits][:ora_inizio],
                    
      })

      @visit = Visit.new(visit_params)
      @visit.user = current_user
      if @visit.save
        calendar_options.insert_event(CALENDAR_ID, visit)
        redirect_to show_calendar_url
      else
        flash[:error] = "Errore salvataggio visita nel database"
        redirect_to new_visit_url
      end
    else
      flash[:error] = "Questa non è un'opzione valida"
      redirect_to new_visit_url
    end
  end

  def delete_visit
    visit_id = params[:visits][:visits]
    calendar_options.delete_event(CALENDAR_ID, visit_id)
    flash[:success] = "La visita con id " + visit_id.to_s + " è stata cancellata"
    redirect_to show_calendar_url
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visit
      @visit = Visit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_params
      if current_user.is_doctor
        params.require(:visits).permit(:tipo, :ora_inizio, :ora_fine, :data_inizio, :data_fine, :paziente)
      else
        params.require(:visits).permit(:tipo, :ora_inizio, :ora_fine, :data_inizio, :data_fine)
      end
    end



    def google_secret
      # puts "************************"
      # puts current_user.token
      # puts current_user.refresh_token #For the user Mario Rossi, that is the one that we are interested in
      # puts "************************"
      Google::APIClient::ClientSecrets.new(
        { "web" =>
          {
            "access_token" => "ya29.Glt1B7LwAzpYh4AE0G-8shM1yR1Y4Vmx5GHOlxFISLHi99_cPzfuP7i3dtXcWIppX-yQslMndcdFAUEopkvqdIpSDQf-RCO4mGlPBh_bCc6_tJ2pPG0IZbWwDKwA",
            "refresh_token" => "1/SyLNtRuLtWB8JB7BHTXdr7lTBtt5cf9jP5s2R6FPSTY",
            "client_id" => Rails.application.secrets.google_client_id,
            "client_secret" => Rails.application.secrets.google_client_secret,
          }
        }
      )
    end




  #before_action :set_visit, only: [:show, :edit, :update, :destroy]

  # # GET /visits
  # # GET /visits.json
  # def index
  #   @visits = Visit.all
  # end

  # # GET /visits/1
  # # GET /visits/1.json
  # def show
  # end

  # # GET /visits/new
  # # def new
  # #   @visit = Visit.new
  # # end

  # # GET /visits/1/edit
  # def edit
  # end

  # POST /visits
  # POST /visits.json
  # def create
  #   @visit = Visit.new(visit_params)

  #   respond_to do |format|
  #     if @visit.save
  #       format.html { redirect_to @visit, notice: 'Visit was successfully created.' }
  #       format.json { render :show, status: :created, location: @visit }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @visit.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /visits/1
  # PATCH/PUT /visits/1.json
  # def update
  #   respond_to do |format|
  #     if @visit.update(visit_params)
  #       format.html { redirect_to @visit, notice: 'Visit was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @visit }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @visit.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /visits/1
  # # DELETE /visits/1.json
  # def destroy
  #   @visit.destroy
  #   respond_to do |format|
  #     format.html { redirect_to visits_url, notice: 'Visit was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end




end
