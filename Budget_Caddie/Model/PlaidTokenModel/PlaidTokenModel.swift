//
//  PlaidTokenModel.swift
//  Budget_Caddie
//
//  Created by Sabin on 02/02/25.
//

import Foundation
import ObjectMapper
import Alamofire

struct PlaidTokenModel: Decodable {
    var linkData: [PlaidTokenDataModel]?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case linkData = "data"
        case status
    }
}

struct PlaidTokenDataModel: Decodable {
    var expiration: String?
    var linkToken: String?
    var requestID: String?

    enum CodingKeys: String, CodingKey {
        case expiration = "expiration"
        case linkToken = "link_token"
        case requestID = "request_id"
    }
}
//class PlaidTokenGenerationModel:NSObject{
//    
//    static let sharedInstance = PlaidTokenGenerationModel()
//    
//    func createNewWorkSpace<T: Mappable>(type: T.Type,
//    with endPointURL: String,
//    urlMethod: HTTPMethod!,
//    params: Parameters?,
//    headers:HTTPHeaders?,
//    viewController : UIViewController,
//    showLoader: Bool? = false,
//    encode: ParameterEncoding? = JSONEncoding.default,
//                                         completion: @escaping(_ result: AFDataResponse<T>?, _ statusCode: ResponseCode) -> Void) {
//        ServiceManager.sharedInstance.executeGetUrl(type: PlaidTokenModel.self, with: "", showLoader: true) { result, statusCode in
//            
//        }
//        
//        
//    }
//   
//}
