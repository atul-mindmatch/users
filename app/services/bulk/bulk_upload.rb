module Bulk 
    class BulkUpload
        def initialize(file)
            @file = file
        end
        def process
            uploaded_file = @file
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
            primary_address = table.by_row[i]["primary_address"]
            secondary_address = table.by_row[i]["secondary_address"]
            @user = User.new(username: username , email: email)
            if @user.save
            	@user_detail = UserDetail.create(first_name: first_name , last_name: last_name , primary_address: primary_address , secondary_address: secondary_address , dob: dob , user_id: @user.id)
						if @user_detail.errors.full_messages_for(:dob).length == 1
							@user.destroy
						end
			else 
                puts @user.errors.full_messages_for(:username)[0]
                puts @user.errors.full_messages_for(:email)[0]
                next
            end
        end
        end
    end
end