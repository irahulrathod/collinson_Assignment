//
//  Constant.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

enum Constant {
    static let weatherEndPoint = "https://api.open-meteo.com/v1/forecast?latitude=%lf&longitude=%lf&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max,snowfall_sum,wind_speed_10m_max,weather_code&timezone=auto"
    
    static let searchCityEndPoint = "https://geocoding-api.open-meteo.com/v1/search?name=%@&count=10&language=en&format=json"
}
