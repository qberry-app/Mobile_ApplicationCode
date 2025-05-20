//
//  ServiceManager.swift
//  Budget_Caddie
//
//  Created by Sabin on 16/01/25.
//

import Foundation
import Alamofire
import ObjectMapper
import AWSS3
class ServiceManager: NSObject {
    class var sharedInstance: ServiceManager {
        struct Static {
            static let instance = ServiceManager()
        }
        return Static.instance
    }
    protocol DataMapping: Mappable, Decodable {}
    var successHandler: ((String, ResponseCode) -> Void)?
    
   
    
    func executePostUrl<T: Mappable>(
            type: T.Type,
            with endPointURL: String,
            params: Parameters? = nil,
            headers: HTTPHeaders? = nil,
            baseURL: String,
            encode: ParameterEncoding? = JSONEncoding.default,
            auth: AuthCredentials? = nil,
            showLoader: Bool,
            completion: @escaping (_ result: AFDataResponse<T>?, _ statusCode: ResponseCode) -> Void
        ) {
            let url = endPointURL
            let urlMethod: HTTPMethod = .post
            
            print("URL Request ----> \(endPointURL)")
            print("Parameter ----> \(params as Any)")
            print("Headers ---> \(String(describing: headers))")
            
            var finalHeaders: HTTPHeaders = headers ?? [:]
                   if let auth = auth {
                       finalHeaders["Authorization"] = auth.basicAuthString
                   }
            
            AF.request(url, method: urlMethod, parameters: params, encoding: encode!, headers: finalHeaders)
                .validate()
                .responseString { response in
                    switch response.result {
                    case .success(let stringResponse):
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 401 {
                                // Handle unauthorized
                            } else if statusCode == 246 {
                                // Handle specific status code
                            } else {
                                // Convert string response to Mappable object
                                if let mappedObject = Mapper<T>().map(JSONString: stringResponse) {
                                    let successResponse = AFDataResponse<T>(
                                        request: response.request,
                                        response: response.response,
                                        data: response.data,
                                        metrics: response.metrics,
                                        serializationDuration: response.serializationDuration,
                                        result: .success(mappedObject)
                                    )
                                    completion(successResponse, self.statusCodeForResponseCode(statusCode))
                                }
                            }
                        }
                    case .failure(let error):
                        print("RESPONSE From server failure: \(error.localizedDescription)")
                        if let statusCode = response.response?.statusCode {
                            completion(nil, self.statusCodeForResponseCode(statusCode))
                        } else {
                            completion(nil, self.statusCodeForResponseCode(URLError.Code.notConnectedToInternet.rawValue))
                        }
                    }
                }
        }
    func executePostUrlWithDecodable<T: Decodable>(
           type: T.Type,
           with endPointURL: String,
           params: Parameters? = nil,
           headers: HTTPHeaders? = nil,
           encode: ParameterEncoding? = JSONEncoding.default,
           auth: AuthCredentials? = nil,
           showLoader: Bool,
           addAuth: Bool = true,
           completion: @escaping (_ result: AFDataResponse<T>?, _ statusCode: ResponseCode) -> Void
       ) {
           let url = endPointURL
           let urlMethod: HTTPMethod = .post
           var finalHeaders: HTTPHeaders = headers ?? [:]
           if addAuth == true {
               if let auth = auth {
                   finalHeaders["Authorization"] = auth.basicAuthString
               }
           }
           print("URL Request ----> \(endPointURL)")
           print("Parameter ----> \(params as Any)")
           print("Headers ---> \(String(describing: headers))")
           
           AF.request(url, method: urlMethod, parameters: params, encoding: encode!, headers: finalHeaders)
               .validate()
               .responseDecodable(of: T.self) { response in
                   if let error = response.error {
                       print("RESPONSE From server failure: \(error.localizedDescription)")
                       if let statusCode = response.response?.statusCode {
                           completion(response, self.statusCodeForResponseCode(statusCode))
                       } else {
                           completion(response, self.statusCodeForResponseCode(URLError.Code.notConnectedToInternet.rawValue))
                       }
                   } else {
                       if let statusCode = response.response?.statusCode {
                           if statusCode == 401 {
                               // Handle unauthorized
                           } else if statusCode == 246 {
                               // Handle specific status code
                           } else {
                               
                               completion(response, self.statusCodeForResponseCode(statusCode))
                           }
                       }
                   }
               }
       }
    func executeGetUrlWithDecodable<T: Decodable>(
        type: T.Type,
        with endPointURL: String,
        params: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        auth: AuthCredentials? = nil,
        showLoader: Bool,
        completion: @escaping (_ result: AFDataResponse<T>?, _ statusCode: ResponseCode) -> Void
    ) {
        let url = endPointURL
        let urlMethod: HTTPMethod = .get
        print("URL Request ----> \(endPointURL)")
        print("Parameters ----> \(params as Any)")
        print("Headers ---> \(String(describing: headers))")
        
        var finalHeaders: HTTPHeaders = headers ?? [:]
        if let auth = auth {
            finalHeaders["Authorization"] = auth.basicAuthString
        }
        
        AF.request(url, method: urlMethod, parameters: params, encoding: URLEncoding.default, headers: finalHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                if let error = response.error {
                    print("RESPONSE From server failure: \(error.localizedDescription)")
                    if let statusCode = response.response?.statusCode {
                        completion(response, self.statusCodeForResponseCode(statusCode))
                    } else {
                        completion(response, self.statusCodeForResponseCode(URLError.Code.notConnectedToInternet.rawValue))
                    }
                } else {
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // Handle unauthorized
                        } else if statusCode == 246 {
                            // Handle specific status code
                        } else {
                            
                            completion(response, self.statusCodeForResponseCode(statusCode))
                        }
                    }
                }
            }
    }
    
    func executeGetUrl<T: Mappable>(
        type: T.Type,
        with endPointURL: String,
        params: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        auth: AuthCredentials? = nil,
        showLoader: Bool,
        completion: @escaping (_ result: AFDataResponse<T>?, _ statusCode: ResponseCode) -> Void
    ) {
        let url = endPointURL
        let urlMethod: HTTPMethod = .get
        
        print("URL Request ----> \(endPointURL)")
        print("Parameters ----> \(params as Any)")
        print("Headers ---> \(String(describing: headers))")
        
        var finalHeaders: HTTPHeaders = headers ?? [:]
        if let auth = auth {
            finalHeaders["Authorization"] = auth.basicAuthString
        }
        
        AF.request(url, method: urlMethod, parameters: params, encoding: URLEncoding.default, headers: finalHeaders)
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let stringResponse):
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // Handle unauthorized
                        } else if statusCode == 246 {
                            // Handle specific status code
                        } else {
                            if let mappedObject = Mapper<T>().map(JSONString: stringResponse) {
                                let successResponse = AFDataResponse<T>(
                                    request: response.request,
                                    response: response.response,
                                    data: response.data,
                                    metrics: response.metrics,
                                    serializationDuration: response.serializationDuration,
                                    result: .success(mappedObject)
                                )
                                completion(successResponse, self.statusCodeForResponseCode(statusCode))
                            }
                        }
                    }
                case .failure(let error):
                    print("RESPONSE From server failure: \(error.localizedDescription)")
                    if let statusCode = response.response?.statusCode {
                        completion(nil, self.statusCodeForResponseCode(statusCode))
                    } else {
                        completion(nil, self.statusCodeForResponseCode(URLError.Code.notConnectedToInternet.rawValue))
                    }
                }
            }
    }
    
    func imageUploadGetPreSignedURLRequest1(preSignedURL: AWSS3GetPreSignedURLRequest, viewController : UIViewController, fileURL:URL, fileName: String, dimention: String, currentItem: Int? = 0, totalCount: Int? = 0, completion: @escaping(_ result: String?,_ statusCode: ResponseCode) -> Void)  {
        print(fileURL)
       
        AWSS3PreSignedURLBuilder.default().getPreSignedURL(preSignedURL).continueWith { (task:AWSTask<NSURL>) -> Any? in
            if let error = task.error as NSError? {
                print("DC: Error: \(error.localizedDescription)")
                return nil
            }
            else {
                let presignedURL = task.result!
                print("DC: Upload presignedURL is: \(String(describing: presignedURL))")
                // Create url request & configure
                var request = URLRequest(url: presignedURL as URL)
                request.httpMethod = "PUT"
                if fileURL.pathExtension == "png" || fileURL.pathExtension == "jpeg" {
                    request.setValue("image/png", forHTTPHeaderField: "Content-Type")
                } else {
                    request.setValue("audio/mp3", forHTTPHeaderField: "Content-Type")
                }
                // Create urlSession add to operarion Queue
                let sessionConfiguration = URLSessionConfiguration.default
                let urlSession = URLSession.init(configuration: sessionConfiguration, delegate: self, delegateQueue: (OperationQueue.main))
                // URLSession UploadTask
                let uploadTask: URLSessionUploadTask = urlSession.uploadTask(with: request, fromFile: (fileURL as URL?)!, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in

                    let httpResponse =  response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200 {
                        completion(fileName,ResponseCode(rawValue: (httpResponse?.statusCode)!)!)
                    }
                    else {
                        if data != nil{
                            completion(fileName,ResponseCode(rawValue: (httpResponse?.statusCode)!)!)
                        }else{
                            completion(fileName,ResponseCode(rawValue: 404)!)
                        }
                        print("DC: AWSManger httpResponse failure \(String(describing: httpResponse))")
                        print("DC: AWSManger httpResponse failure \(String(describing: httpResponse?.statusCode))")
                    }
                })
                uploadTask.resume()
            }
            return nil
        }
    }
    
    func imageUploadGetPreSignedURLRequestWithoutLoader(preSignedURL: AWSS3GetPreSignedURLRequest, viewController : UIViewController, fileURL:URL, fileName: String, dimention: String, currentItem: Int? = 0, totalCount: Int? = 0, completion: @escaping(_ result: String?,_ statusCode: ResponseCode) -> Void)  {
        print(fileURL)
       AWSS3PreSignedURLBuilder.default().getPreSignedURL(preSignedURL).continueWith { (task:AWSTask<NSURL>) -> Any? in
            if let error = task.error as NSError? {
                print("DC: Error: \(error.localizedDescription)")
                return nil
            }
            else {
                let presignedURL = task.result!
                print("DC: Upload presignedURL is: \(String(describing: presignedURL))")
                // Create url request & configure
                var request = URLRequest(url: presignedURL as URL)
                request.httpMethod = "PUT"
                if fileURL.pathExtension == "png" || fileURL.pathExtension == "jpeg" {
                    request.setValue("image/png", forHTTPHeaderField: "Content-Type")
                } else {
                    request.setValue("audio/mp3", forHTTPHeaderField: "Content-Type")
                }
                // Create urlSession add to operarion Queue
                let sessionConfiguration = URLSessionConfiguration.default
                let urlSession = URLSession.init(configuration: sessionConfiguration, delegate: self, delegateQueue: (OperationQueue.main))
                // URLSession UploadTask
                let uploadTask: URLSessionUploadTask = urlSession.uploadTask(with: request, fromFile: (fileURL as URL?)!, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in

                    let httpResponse =  response as? HTTPURLResponse
                    if httpResponse?.statusCode == 200 {
                        completion(fileName,ResponseCode(rawValue: (httpResponse?.statusCode)!)!)
                    }
                    else {
                        if data != nil{
                            completion(fileName,ResponseCode(rawValue: (httpResponse?.statusCode)!)!)
                        }else{
                            completion(fileName,ResponseCode(rawValue: 404)!)
                        }
                        print("DC: AWSManger httpResponse failure \(String(describing: httpResponse))")
                        print("DC: AWSManger httpResponse failure \(String(describing: httpResponse?.statusCode))")
                    }
                })
                uploadTask.resume()
            }
            return nil
        }
    }
    func imageUploadGetPreSignedURLRequest(preSignedURL: AWSS3GetPreSignedURLRequest, viewController : UIViewController, fileURL:URL, fileName: String, dimention: String, currentItem: Int? = 0, totalCount: Int? = 0,type: String? = "", completion: @escaping(_ result: String?,_ statusCode: ResponseCode) -> Void)  {
        print(fileURL)
        AWSS3PreSignedURLBuilder.default().getPreSignedURL(preSignedURL).continueWith { (task:AWSTask<NSURL>) -> Any? in
            if let error = task.error as NSError? {
                print("DC: Error: \(error.localizedDescription)")
                return nil
            }
            else {
                let presignedURL = task.result!
                print("DC: Upload presignedURL is: \(String(describing: presignedURL))")
                // Create url request & configure
                var request = URLRequest(url: presignedURL as URL)
                request.httpMethod = "PUT"
                if fileURL.pathExtension == "png" || fileURL.pathExtension == "jpeg" {
                    request.setValue("image/png", forHTTPHeaderField: "Content-Type")
                } else {
                    request.setValue("audio/mp3", forHTTPHeaderField: "Content-Type")
                }
                // Create urlSession add to operarion Queue
                let sessionConfiguration = URLSessionConfiguration.default
                let urlSession = URLSession.init(configuration: sessionConfiguration, delegate: self, delegateQueue: (OperationQueue.main))
                // URLSession UploadTask
                let uploadTask: URLSessionUploadTask = urlSession.uploadTask(with: request, fromFile: (fileURL as URL?)!, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in

                    let httpResponse =  response as? HTTPURLResponse
                    if httpResponse?.statusCode == 200 {
                        if type != "camera" {
                        }
                        completion(fileName,ResponseCode(rawValue: (httpResponse?.statusCode)!)!)
                    }
                    else {
                        if data != nil{
                            if type != "camera" {
                            }
                            completion(fileName,ResponseCode(rawValue: (httpResponse?.statusCode)!)!)
                        }else{
                            if type != "camera" {
                            }
                            completion(fileName,ResponseCode(rawValue: 404)!)
                        }
                        print("DC: AWSManger httpResponse failure \(String(describing: httpResponse))")
                        print("DC: AWSManger httpResponse failure \(String(describing: httpResponse?.statusCode))")
                    }
                })
                uploadTask.resume()
            }
            return nil
        }
    }
    
        func topViewController(
            base: UIViewController? = (UIApplication.shared.delegate as? AppDelegate)!.window?.rootViewController
        ) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return topViewController(base: nav.visibleViewController)
            }
            if let tab = base as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return topViewController(base: selected)
                }
            }
            if let presented = base?.presentedViewController {
                return topViewController(base: presented)
            }
            return base
        }
    func statusCodeForResponseCode(_ statusCode:Int) -> ResponseCode {
        
        var responseCode : ResponseCode?
        switch statusCode {
        case 200:
            responseCode = .success
            break
        case 201:
            responseCode = .inVaildEmail
        case 202:
            responseCode = .inValidOTP
        case 203:
            responseCode = .inValidPwd
        case 204:
            responseCode = .tokenMismatch
        case 206:
            responseCode = .fileUnvailable
        case 207:
            responseCode = .srIdUnvailable
        case 208:
            responseCode = .isrIdUnvailable
        case 209:
            responseCode = .fileNameUnvailable
        case 210:
            responseCode = .unExpectedError
        case 211:
            responseCode = .pwdInvalid
        case 212:
            responseCode = .previousPwdSame
        case 230:
            responseCode = .permissionDisAllow
        case 302:
            responseCode = .emailAlreadyExists
        case 400:
            responseCode = .badRequest
        case 401:
            responseCode = .unAuthorization
        case 403:
            responseCode = .forbidden
        case 404:
            responseCode = .badRequest
        case 408:
            responseCode = .timeOut
        case 500:
            responseCode = .serviceUnavailable
        default:
            responseCode = .timeOut
        }
        return responseCode ?? .success;
    }
}
enum ResponseCode: Int {
    
    // Requested api returns expected response
    case success                 = 200
    
    // Email Id not found
    case inVaildEmail           = 201
    
    // Invaild OTP
    case inValidOTP             = 202
    
    // Password Mismatching
    case inValidPwd             = 203
    
    // Token Mismatching
    case tokenMismatch          = 204
    
    // File not found
    case fileUnvailable         = 206
    
    // SR ID not found
    case srIdUnvailable        = 207
    
    // ISR ID not found
    case isrIdUnvailable        = 208
    
    // File name not found
    case fileNameUnvailable     = 209
    
    // Some thing went wrong
    case unExpectedError        = 210
    
    // Invalid password
    case pwdInvalid             = 211
    
    // Previous password already exists
    case previousPwdSame        = 212
    
    // User display or read permission missing
    case permissionDisAllow     = 230
    
    // Email already Exists
    case emailAlreadyExists      = 302
    
    // The HTTP request is incomplete or malformed.
    case badRequest             = 400
    
    // Authorization is required to use the service
    case unAuthorization        = 401
    
    // User do not have permission to access the database.
    case forbidden              = 403
    
    // The named database is not running on the server, or the named web service does not exist.
    case notFound               = 404
    
    // The maximum connection idle time was exceeded while receiving the request
    case timeOut                = 408
    
    // An internal error occurred. The request could not be processed.
    case serviceUnavailable     = 500
    
    // No internet
    case noNetwork              = -1
}

struct AuthCredentials {
        let username: String
        let password: String
        
        var basicAuthString: String {
            let credentialData = "\(username):\(password)".data(using: .utf8)!
            let base64Credentials = credentialData.base64EncodedString()
            return "Basic \(base64Credentials)"
        }
    }
extension ServiceManager: URLSessionDelegate {
    
}
