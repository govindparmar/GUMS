class UsersController < ApplicationController

  # User-friendly "my profile" page
  def show
	@user = User.find(params[:id])
	@viewed_org = Organization.find(@user.organization_id).id
	@loggedin_org = session[:user_id] == nil ? nil : Organization.find(User.find(session[:user_id]).organization_id).id
  end
  
  # Debug page; not accessible in production
  def info
	@user = User.find(params[:id])
  end
  
  # New user page grabs organizations which are in a seperate table
  def new
	@user = User.new
	@organizations = Organization.all
  end
  
 # Post target for 'user#new'
 # The reason there's a separate method for the admin add user page is because that page contains the ability to create admins, potentially,
 # whereas a manual user sign up has that hard coded to false for obvious reasons.
 def create
    checkexists = User.find_by(email: user_params[:email], organization_id: user_params[:organization_id])
	if checkexists
		flash[:danger] = 'A user with this email address already exists within the specified organization'
		redirect_to '/signup.html'
	else
		@user = User.new(user_params)
		@user.write_attribute(:is_admin, false)
		if @user.save
			render 'show'
		else
			render 'new'
		end
	end
  end
  
  # Loggedin_user is simply to check for that the user being copied is actually logged in and not someone else being malicious.
  def copyuser
	@user = User.find(params[:id])
	@loggedin_user = session[:user_id]
	@organizations = Organization.all
  end
  
  def docopyuser
	@newuser = User.find(params[:id]).dup
	@newuser.write_attribute(:organization_id, params[:user][:organization_id])
	@newuser.write_attribute(:is_admin, false)
	checkexists = User.find_by(email: @newuser.email, organization_id: @newuser.organization_id)
	if checkexists
		flash[:danger] = 'A user with this email address is already in the target organization'
		redirect_to '/'
	else
		if @newuser.save
			flash[:success] = 'Copied successfully to the new organization!'
			redirect_to '/'
		else
			flash[:danger] = 'An error occurred when copying to the new organization.'
			redirect_to '/users/' + user_params[:id].to_s + '/copyuser'
		end
	end
  end
  
  def moveuser
	@user = User.find(params[:id])
	@loggedin_user = session[:user_id]
	@organizations = Organization.all
  end
  
  def domoveuser
	@user = User.find(params[:id])
	@user.write_attribute(:organization_id, params[:user][:organization_id])
	@user.write_attribute(:is_admin, false)
	
	checkexists = User.find_by(email: @user.email, organization_id: @user.organization_id)
	if checkexists
		flash[:danger] = 'A user with this email address is already in the target organization'
		redirect_to '/'
	else
		if @user.save
			flash[:success] = 'Moved successfully to the new organization!'
			redirect_to '/logout'
		else
			flash[:danger] = 'An error occurred when moving to the new organization.'
			redirect_to '/users/' + @user.id.to_s + '/moveuser'
		end
	end
  end
  
  def edit
	@user = User.find(params[:id])
	@editing_org = Organization.find(@user.organization_id).id
	@loggedin_org = session[:user_id] == nil ? nil : Organization.find(User.find(session[:user_id]).organization_id).id
  end
  

  def index
  	@users = User.all
	@loggedin_org = session[:user_id] == nil ? nil : Organization.find(User.find(session[:user_id]).organization_id).id

  end
  
  def adminedit
	@user = User.find(params[:id])
	@editing_org = Organization.find(@user.organization_id).id
	@loggedin_org = session[:user_id] == nil ? nil : Organization.find(User.find(session[:user_id]).organization_id).id
  end
  
  def adminaddnew
    @user = User.new
	@loggedin_org = session[:user_id] == nil ? nil : Organization.find(User.find(session[:user_id]).organization_id).id
  end
  
  def adminsavenew
    @user = User.new(user_params)
	@user.write_attribute(:organization_id, Organization.find(User.find(session[:user_id]).organization_id).id)
	checkexists = User.find_by(email: @user.email, organization_id: @user.organization_id)
	if checkexists 
		flash[:danger] = 'A user with this email address already exists in your organization.'
		redirect_to '/users/adminaddnew'
	else
		if @user.save
			flash[:success] = 'User created successfully'
			redirect_to '/users'
		else
			flash[:danger] = 'User creation failed'
			redirect_to '/users/adminaddnew'
		end
	end
  end
  
  
  def update
	@user = User.find(params[:id])
	if @user.update_attributes(user_params)
		flash[:success] = "Changes Saved"
		redirect_to @user
	else
		render 'edit'
	end
  end
  
  private
	def user_params
		params.require(:user).permit(:full_name, :email, :phone_number, :date_of_birth, :organization_id, :is_admin, :password, :password_confirmation)
	end
end
