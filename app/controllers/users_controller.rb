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
      username = params["user"]["username"]
      email = params["user"]["email"]
      first_name = params["user_detail"]["first_name"]
      last_name =  params["user_detail"]["last_name"]
      dob =  params["user_detail"]["dob"]
      address =  params["user_detail"]["address"]


      temp_dob = dob
      temp_dob = temp_dob.split('-')

      @user = User.new(user_params)    
      if !dob.empty? and temp_dob[0].to_i < 2002  and @user.save
        @user_detail = UserDetail.create(first_name: first_name , last_name: last_name , address: address , dob: dob , user_id: @user.id)
        redirect_to @user
      else
        flash["alert"]  = @user.errors.full_messages.to_sentence
        if dob.empty?
        flash["dob"] =  "DOB can't be empty" 
        end
        if temp_dob[0].to_i > 2002
          flash['dob_valiidate'] = "age must be greater than 18"
        end
        puts @user.errors.full_messages.to_sentence
        redirect_to :action => 'new'
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
      (table.size).times do |i|
        email = table.by_row[i]["email"]
        username = table.by_row[i]["username"]
        first_name = table.by_row[i]["first_name"]
        last_name = table.by_row[i]["last_name"]
        dob = table.by_row[i]["dob"]
        address = table.by_row[i]["address"]
        @user = User.new(username: username , email: email)
        if @user.save
          @user_detail = UserDetail.create(first_name: first_name , last_name: last_name , address: address , dob: dob , user_id: @user.id)
        else 
          puts @user.errors.full_messages_for(:username)[0]
          puts @user.errors.full_messages_for(:email)[0]
          next
        end
      end
      redirect_to :users
    end
    
    # private
      
    #   def user_params
    #     params.require(:user).permit(:username, :email, :first_name, :last_name , :dob)
    #   end
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
      
end
