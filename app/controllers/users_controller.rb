require 'csv'
class UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.order('created_at DESC').paginate(page: params[:page])    
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
    
  def create
    @user = User.new(user_params)
    if  @user.save
      user_detail = user_detail_params
      user_detail["user_id"] = @user.id
      @user_detail = UserDetail.new(user_detail)
      if @user_detail.save
        redirect_to @user
      else
        if @user.errors
          flash["alert"]  = @user.errors.full_messages.to_sentence
        end
        if @user_detail.errors
          flash["age"] =   @user_detail.errors.full_messages.to_sentence
        end
        redirect_to :action => 'new'
      end
    else
      if @user.errors
        flash["alert"]  = @user.errors.full_messages.to_sentence
      end
      redirect_to :action => 'new'
    end
  end

  def destroy
    user = User.find_by(id: params["id"])
    user.destroy
    redirect_to :users
  end
  


  def upload
    Bulk::BulkUpload.new(params[:picture]).process
    redirect_to :users
  end
    
  def update
    @user = User.find(params[:id])
    @user_detail = UserDetail.find_by(user_id: params[:id])
    if @user.update(user_params) and @user_detail.update(user_detail_params)
      redirect_to :users 
    else 
      flash["user_alert"]  = @user.errors.full_messages.to_sentence
      flash["user_detail_alert"]
      puts @user.errors.full_messages.to_sentence
      redirect_to :action => 'edit'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:username, :email)
    end

    def user_detail_params
      params.require(:user_detail).permit(:first_name , :last_name , :dob ,:primary_address , :secondary_address)
    end  
end
