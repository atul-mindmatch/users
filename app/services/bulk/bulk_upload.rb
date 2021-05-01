module Bulk 
  class BulkUpload
    def initialize(file)
       @file = file
    end

    def process
			#binding.pry
      uploaded_file = @file
      File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
        file.write(uploaded_file.read)
      end

      table = CSV.parse(File.read(Rails.root.join('public', 'uploads', uploaded_file.original_filename)), headers: true)
      x = 0
      batch_size = 1000

      while x < (table.size) 
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
          user = { "email" => ActiveRecord::Base.connection.quote(email) , "username" => ActiveRecord::Base.connection.quote(username) }
          user_id  = 1
          all_users.push(<<-SQL.chomp)
            (
              #{user.values.join(',')},
              NOW(),
              NOW()
            )
          SQL
          x = x + 1;
          user_detail = { 
            "first_name" => ActiveRecord::Base.connection.quote(first_name), 
            "last_name" => ActiveRecord::Base.connection.quote(last_name),
            "dob" => ActiveRecord::Base.connection.quote(dob),
            "user_id" => 1,
            "primary_address" => ActiveRecord::Base.connection.quote(primary_address),
            "secondary_address" => ActiveRecord::Base.connection.quote(secondary_address) 
          }
          all_user_details.push(user_detail)
          if(x >= table.size) 
            break
          end
        end
        if(x <= table.size)
          sql = <<-SQL.chomp
            INSERT INTO users (
            email, username, created_at, updated_at
            ) VALUES #{all_users.join(',')}
            SQL
          user_ids = ActiveRecord::Base.connection.execute(sql+'returning id')
        end
        temp = user_ids[0]["id"]    
        for user_detail in all_user_details
          user_detail["user_id"] = temp
          temp = temp + 1;
        end

        for user_detail in all_user_details
          user_details.push(<<-SQL.chomp)
          (
            #{user_detail.values.join(',')},
            NOW(),
            NOW()
          )
          SQL
        end

        if(x <= table.size)
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