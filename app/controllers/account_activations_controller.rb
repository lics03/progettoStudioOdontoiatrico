class AccountActivationsController < ApplicationController
  
  def activate
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      sign_in user
      flash[:success] = "Account attivato!"
      redirect_to root_url
    else
      flash[:danger] = "Link di attivazione non valido"
      redirect_to root_url
    end
  end
end