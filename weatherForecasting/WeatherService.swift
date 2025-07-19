//
//  WeatherService.swift
//  weatherForecasting
//
//  Created by Niranjan Kumar on 19/07/25.
//

import Foundation
class WeatherService {
    
    func getWeatherData(callBackHandler:@escaping(_ weatherData:WeatherData)->Void){
        var params = ParametersStruct(method: HTTPMethod.GET.rawValue,bodyData:nil,queryParams: [:],path: "users")
        
        Repository.shared.callApi(parametersS: params) { (response:ApiResponseModel<[UserDTO]>?, apiError) in
                print("=========response_in_mainviewmodel=======\(response)")
        }
    }
}
