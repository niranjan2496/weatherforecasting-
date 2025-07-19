//
//  ApiResponse.swift
//  weatherForecasting
//
//  Created by Niranjan Kumar on 15/07/25.
//

import Foundation

public class ApiResponseModel<T:Codable>:Codable {
      var status: String? = nil
       var message: String? = nil
       var code:Int = 0
       var data: T? = nil
}
