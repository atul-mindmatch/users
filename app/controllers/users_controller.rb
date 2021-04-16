require 'csv'
class UsersController < ApplicationController
    def index
        @users = User.all
    end

    def show
        @user = User.find(params[:id])
    end

    def new
        @user = User.new
    end
    
    def create
      username = params["user"]["username"]
      email = params["user"]["email"]
      first_name = params["user_detail"]["first_name"]
      last_name =  params["user_detail"]["last_name"]
      dob =  params["user_detail"]["dob"]
      address =  params["user_detail"]["address"]

      @user = User.new(username: username , email: email)    
      if @user.save
        @user_detail = UserDetail.create(first_name: first_name , last_name: last_name , address: address , dob: dob , user_id: @user.id)

        redirect_to @user
      else
        render :new
      end
    end

    def destroy
      user = User.find_by(id: params["id"])
      user.destroy
      redirect_to :users
    end
  


    def upload
      uploaded_file = params[:picture]
      puts uploaded_file.class
      File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
        file.write(uploaded_file.read)
      end
      table = CSV.parse(File.read(Rails.root.join('public', 'uploads', uploaded_file.original_filename)), headers: true)
      100.times do |i|
        email = table.by_row[i]["email"]
        username = table.by_row[i]["username"]
        first_name = table.by_row[i]["first_name"]
        last_name = table.by_row[i]["last_name"]
        dob = table.by_row[i]["dob"]
        address = table.by_row[i]["address"]
        puts email , username , first_name , last_name , dob , address
        @user = User.new(username: username , email: email)
        if @user.save
          @user_detail = UserDetail.create(first_name: first_name , last_name: last_name , address: address , dob: dob , user_id: @user.id)
        end
      end
      redirect_to :users
    end
    
    # private
      
    #   def user_params
    #     params.require(:user).permit(:username, :email, :first_name, :last_name , :dob)
    #   end
    def update
      user = User.find(params[:id])
      user.username = params["user"]["username"]
      user.email = params["user"]["email"]
      user.user_detail.first_name = params["user_detail"]["first_name"]
      user.user_detail.last_name =  params["user_detail"]["last_name"]
      user.user_detail.dob =  params["user_detail"]["dob"]
      user.user_detail.address =  params["user_detail"]["address"]
      user.save
      

      redirect_to :users
    end

    def edit
      @user = User.find(params[:id])
    end
      
end
