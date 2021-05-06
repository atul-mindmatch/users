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
      x = 0
      batch_size = 1000
      
      while x < (table.size) 
        users = []
        all_users = []
        all_user_details = []
        user_details = []
        (batch_size).times do |i|
	  email = table.by_row[x]["email"]
          username = table.by_row[x]["username"]
          first_name = table.by_row[x]["first_name"]
          last_name = table.by_row[x]["last_name"]
          dob = table.by_row[x]["dob"]
          primary_address = table.by_row[x]["primary_address"]
          secondary_address = table.by_row[x]["secondary_address"]
          found1 = false
          found2 = false
          for user in users do
            if user["email"] == ActiveRecord::Base.connection.quote(email)
              found1 = true
            end
            if user["username"] == ActiveRecord::Base.connection.quote(username)
              found2 = true
            end
          end
          if (User.find_by(email: email) == nil and User.find_by(username: username) == nil and !found1 and !found2)
            user = { "email" => ActiveRecord::Base.connection.quote(email) , "username" => ActiveRecord::Base.connection.quote(username) }
            user_detail = { 
            "first_name" => ActiveRecord::Base.connection.quote(first_name), 
            "last_name" => ActiveRecord::Base.connection.quote(last_name),
            "dob" => ActiveRecord::Base.connection.quote(dob),
            "user_id" => nil,
            "primary_address" => ActiveRecord::Base.connection.quote(primary_address),
            "secondary_address" => ActiveRecord::Base.connection.quote(secondary_address) 
            } 
            users.push(user)
            all_user_details.push(user_detail)
          end
          x = x + 1;
          if(x >= table.size) 
            break
          end
        end
        if(x <= table.size)
          for user in users
            all_users.push(<<-SQL.chomp)
            (
              #{user.values.join(',')},
              NOW(),
              NOW()
            )
            SQL
          end

          if(all_users.size != 0)
            sql = <<-SQL.chomp
            INSERT INTO users (
              email, username, created_at, updated_at
              ) VALUES #{all_users.join(',')}
              SQL
            user_ids = ActiveRecord::Base.connection.execute(sql+'returning id')
          end
        end
        temp = 0    
        for user_detail in all_user_details
          user_detail["user_id"] = user_ids[temp]["id"]
          temp = temp + 1;
        end

        if(all_users.size != 0)
          for user_detail in all_user_details
            user_details.push(<<-SQL.chomp)
            (
              #{user_detail.values.join(',')},
              NOW(),
              NOW()
            )
            SQL
          end
          sql = <<-SQL.chomp
            INSERT INTO user_details (
              first_name , last_name , dob, user_id ,primary_address , secondary_address , created_at, updated_at
              ) VALUES #{user_details.join(',')}
            SQL

          ActiveRecord::Base.connection.execute(sql)
        end
      end
    end
  end
end
