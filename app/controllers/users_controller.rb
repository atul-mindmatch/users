require 'csv'
class UsersController < ApplicationController
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
    dob =  params["user_detail"]["dob"]
    @user = User.new(user_params)
    if @user.save
      user_detail = user_detail_params
      user_detail["user_id"] = @user.id
      @user_detail = UserDetail.new(user_detail)
      if @user_detail.save
        redirect_to @user
      else 
        @user.destroy
        flash["alert"]  = @user.errors.full_messages.to_sentence
        flash["age"] =   @user_detail.errors.full_messages.to_sentence
        if dob.empty?
        flash["dob"] =  "DOB can't be empty" 
        end
        redirect_to :action => 'new'
      end
    else
      flash["alert"]  = @user.errors.full_messages.to_sentence
      flash["age"] =   @user_detail.errors.full_messages.to_sentence
      if dob.empty?
      flash["dob"] =  "DOB can't be empty" 
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
      @user.username = params["user"]["username"]
      @user.email = params["user"]["email"]
      @user.user_detail.first_name = params["user_detail"]["first_name"]
      @user.user_detail.last_name =  params["user_detail"]["last_name"]
      @user.user_detail.dob =  params["user_detail"]["dob"]
      @user.user_detail.address =  params["user_detail"]["address"]
      if @user.save
        redirect_to :users
      else 
        flash["alert"]  = @user.errors.full_messages.to_sentence
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
