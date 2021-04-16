import csv 
from faker import Faker
fake = Faker()
    
# field names 
fields = ['username', 'first_name', 'last_name', 'email' , 'dob' , 'address'] 
    
# data rows of csv fil
rows = []
for i in range(1000): 
    rows.append([fake.first_name().lower() ,fake.first_name() , fake.last_name(), fake.email() , fake.date() , fake.address()])

    
# name of csv file 
filename = "file.csv"
    
# writing to csv file 
with open(filename, 'w') as csvfile: 
    # creating a csv writer object 
    csvwriter = csv.writer(csvfile) 
        
    # writing the fields 
    csvwriter.writerow(fields) 
        
    # writing the data rows 
    csvwriter.writerows(rows)
