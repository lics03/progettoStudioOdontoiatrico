class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end
    
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Benvenuto!"
      redirect_to @user
    else
      render 'new'
    end
  end



  def confirm
    @user=User.new(user_params)
    unless @user.valid?
      render :new
    end
  end



  private

    def user_params
      params.require(:user).permit(:nome, :cognome, :codice_fiscale, :sesso, :data_nascita, 
                                    :nazione_nascita, :luogo_nascita, :nazione_residenza, 
                                    :citta_residenza, :indirizzo, :email, :numero_telefono, 
                                    :password, :password_confirmation)
    end
end
