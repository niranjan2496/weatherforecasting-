//
//  WeatherReposity.swift
//  weatherForecasting
//
//  Created by Niranjan Kumar on 19/07/25.
//

import Foundation
class WeatherReposity {
    
    func getWeatherData(url:URL,completionHandler:@escaping (_ weather:WeatherApiResponseDTO?,_ error:String?)->Void){
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do{
                let httpResponse = response as! HTTPURLResponse
                print("===request===\(httpResponse.url?.absoluteString ?? "")")
                print("===headers===\(httpResponse.allHeaderFields)")
                print("===StatusCode===\(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200){
                    let json = try? JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("ResponseData=========\(json ?? "")")
                    let finalResponse:WeatherApiResponseDTO = try JSONDecoder().decode(WeatherApiResponseDTO.self, from: data!)
                    DispatchQueue.main.async{
                        completionHandler(finalResponse,nil)
                    }
                }else if(httpResponse.statusCode == 500){
                    completionHandler(nil,"Internal Server Error")
                }else{
                    DispatchQueue.main.async{
                        completionHandler(nil,error?.localizedDescription)
                    }
                }
            }catch{
                print("=====\(error)")
                DispatchQueue.main.async{
                    completionHandler(nil, "Failed to parse server data. Please try again later.")
                }
            }
        }.resume()
    }
}
