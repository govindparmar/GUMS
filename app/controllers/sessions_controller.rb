class SessionsController < ApplicationController
  def new
	@organizations = Organization.all
  end
  def create
	@user = User.find_by(email:  params[:session][:email].downcase, organization_id: params[:session][:organization_id])
	if @user && @user.authenticate(params[:session][:password])
		log_in @user
		redirect_to @user
	else
		flash[:danger] = 'Invalid email/password/organization combination'
		redirect_to '/login'
	end
  end
  def destroy
	log_out
	redirect_to root_url
  end
end
