class PagesController < ApplicationController

  def home
    @values = api_spotter
    @markers = [
      {
        lat: @values[:latitude][-1],
        lng: @values[:longitude][-1]
      }
    ]
  end

  private

  def api_spotter

    response = RestClient.get("https://api.sofarocean.com/api/wave-data?spotterId=SPOT-0222&token=#{ENV["SPOTTER_TOKEN"]}&includeWindData=true")
    spotter_response = JSON.parse(response)
    significantwaveheight = []
    peakperiod = []
    meanperiod = []
    peakdirection =[]
    timestamp =[]
    latitude = []
    longitude =[]
    wind_speed = []
    wind_direction = []


    spotter_response["data"]["waves"].each do |item|
      significantwaveheight << item["significantWaveHeight"]
      peakperiod << item["peakPeriod"]
      meanperiod << item["meanPeriod"]
      peakdirection << item["peakDirection"]
      x = item["timestamp"]
      date_time = DateTime.parse x
      timestamp << date_time.strftime("%Y-%m-%d %Hh")
      latitude << item["latitude"]
      longitude << item["longitude"]
    end

    spotter_response["data"]["wind"].each do |item|
      wind_speed << item["speed"]
      wind_direction << item["direction"]
    end

    response = RestClient.get("https://api.sofarocean.com/api/latest-data?spotterId=SPOT-0222&token=#{ENV["SPOTTER_TOKEN"]}")
    spotter_response = JSON.parse(response)
    
    batteryvoltage = spotter_response["data"]["batteryVoltage"]
    batterypower = spotter_response["data"]["batteryPower"]
    solarvoltage = spotter_response["data"]["solarVoltage"]
    humidity = spotter_response["data"]["humidity"]

    params = {}
    params[:significantwaveheight] = significantwaveheight
    params[:peakperiod] = peakperiod
    params[:meanperiod] = meanperiod
    params[:peakdirection] = peakdirection
    params[:timestamp] = timestamp
    params[:latitude] = latitude
    params[:longitude] = longitude
    params[:wind_speed] = wind_speed
    params[:wind_direction] = wind_direction
    params[:batteryvoltage] = batteryvoltage
    params[:batterypower] = batterypower
    params[:solarvoltage] = solarvoltage
    params[:humidity] = humidity
    params = params.to_h
  end
  
end
