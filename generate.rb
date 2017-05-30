require "json"
require "open-uri"
require 'soda'
require 'rest_client'
require 'date'
require 'time'
require 'active_support/time'

time = Time.new

yyyy = time.strftime("%Y")
mm = time.strftime("%m")

mm = mm.to_i - 3 
mm = mm.to_s

  if mm.to_i <= 0
    yyyy = yyyy.to_i - 1
    yyyy = yyyy.to_s
    mm = mm.to_i + 12
    mm = mm.to_s
  end



days = Time.days_in_month(mm.to_i,yyyy.to_i)

client = SODA::Client.new({:domain => "XXXX", :username => "XXXX", :password => "XXXX", :app_token => "XXXX"})



#u = []
u = ["electricity"]
@rows =[]

u.each do |uu|



  x = open("XXXX="+yyyy+"-"+mm+"-01&numberOfMonths=1","Content-Type" => "text/json")




#  sites = JSON.parse(y.read)
#  readings = [] 
  readings = JSON.parse( x.read)

#  sites["Response"].each do |l|

    readings["Response"].each do |m|


      if m["DataSetId"] == 10508

      gen = (m["Consumption"]).round
      mwh = (m["Consumption"]/(1000*days)).round
      equiv = (mwh*365*1000/3300).round 
#        @rows << [l["Location"],l["Utility"],m["Consumption"],l["Units"],m["StartDate"][0..3],m["StartDate"][5..6]]
 @rows << [yyyy,mm,gen,mwh,equiv]


      end

 #   end

  end

end

puts @rows


@update = []

@rows.each do |x|

     @update << {
    "Year" => x[0],
    "Month" => x[1],
    "Total_Generation_kWh" => x[2],
    "MWh_per_day" => x[3],
    "equiv_3300kWh_pa_houses" => x[4]
    }
end

@response = client.post("XXXX-XXXX", @update)

#USE WITH EXTREME CARE THIS CLEARS DATASET
#@response = client.put("ak9k-3z8a",{})
