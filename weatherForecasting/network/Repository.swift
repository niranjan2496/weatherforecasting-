//
//  ApiHandler.swift
//  weatherForecasting
//
//  Created by Niranjan Kumar on 15/07/25.
//

import Foundation

struct ParametersStruct {
    var method:String = HTTPMethod.GET.rawValue
    var bodyData:Data? = nil
    var queryParams:[String:String]?=[:]
    var url:String=""
    
    init(method:String, bodyData:Data?,queryParams:[String:String],path:String) {
        self.method = method
        self.bodyData = bodyData
        self.queryParams = queryParams
        self.url = path
    }
}

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

class Repository {
    static let shared = Repository()
    func callApi<T>(parametersS:ParametersStruct,callBackHandler:@escaping (_ response:ApiResponseModel<T>?,_ apiError:String?)->Void) {
        
        DispatchQueue(label: "network",qos: .background).async{
                    if NetworkConnectionManager.shared.isConnected == false{
                        callBackHandler(nil,"Network Connection is not available")
                        return
                    }
            
            var headers:[String:String]=[ "Content-Type": "application/json" ]
            if(!parametersS.url.contains("authenticate/user")){
                //            headers["Authorization"] = UserDefaultsUtil.getJWTToken()
                headers["x-timezone"] =  "\(TimeZone.ReferenceType.default.identifier)"
            }
            
            var urlComponent = URLComponents(string: baseURLString+parametersS.url)!
            
            let queryItems = parametersS.queryParams?.map { URLQueryItem(name: $0.key, value: $0.value) }
            if(queryItems!.count>0){
                urlComponent.queryItems = queryItems
            }
            
            var request = URLRequest(url: urlComponent.url!)
            
            request.httpMethod = parametersS.method
            
            if(parametersS.method==HTTPMethod.POST.rawValue){
                
                let json = try? JSONSerialization.jsonObject(with: parametersS.bodyData ?? Data() , options: JSONSerialization.ReadingOptions.allowFragments)
                print("bodyData=========\(json ?? "")")
                request.httpBody = parametersS.bodyData
            }
            
            request.allHTTPHeaderFields = headers
            //Now use this URLRequest with Alamofire to make request
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                do{
                    let httpResponse = response as! HTTPURLResponse
                    print("===request===\(httpResponse.url?.absoluteString ?? "")")
                    print("===headers===\(httpResponse.allHeaderFields)")
                    print("===StatusCode===\(httpResponse.statusCode)")
                    if(httpResponse.statusCode == 200){
                        let json = try? JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        print("ResponseData=========\(json ?? "")")
                        let finalResponse:ApiResponseModel<T>=try JSONDecoder().decode(ApiResponseModel<T>.self, from: data!)
                        DispatchQueue.main.async{
                            callBackHandler(finalResponse,nil)
                        }
                    }else if(httpResponse.statusCode == 500){
                        callBackHandler(nil,"Internal Server Error")
                    }else{
                        DispatchQueue.main.async{
                            callBackHandler(nil,error?.localizedDescription)
                        }
                    }
                } catch{
                    print("=====\(error)")
                    DispatchQueue.main.async{
                        callBackHandler(nil, "Failed to parse server data. Please try again later.")
                    }
                }
            }.resume()
        }
    }

}
