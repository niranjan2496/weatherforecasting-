//
//  MainViewModel.swift
//  weatherForecasting
//
//  Created by Niranjan Kumar on 16/07/25.
//

import Foundation
class MainViewModel:ObservableObject {
    @Published var weatherData:WeatherData? = nil
    var weatherService:WeatherService = WeatherService()
    
    init(){
        refreshWeatherData()
    }
    
    func refreshWeatherData(){
        weatherService.getWeatherData { [weak self] weatherData in
            self?.weatherData = weatherData
        }
    }
}
