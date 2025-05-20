//
//  AWSUploadManager.swift
//  Pixly
//
//  Created by MAC-OBS-26 on 01/04/21.
//  Copyright © 2021 MAC-OBS-27. All rights reserved.
//

import Foundation
import AWSS3
import WXImageCompress

class AWSUploadManager: NSObject {
    var imageDimention = "600x600"
    let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
    class var sharedInstance: AWSUploadManager {
        struct Static {
            static let instance = AWSUploadManager()
        }
        return Static.instance
    }
    
    // MARK: To Upload Image to AWS
    func UploadImageToAWS(uploadImage: UIImage!,type: String? = "",viewController: UIViewController!, completion: @escaping(_ uploadUrl: String, _ statusCode: Int) -> Void) {
        // MARK: create file path
        let filePath: URL = createFilePath(image: uploadImage)
        let globalFileName = ProcessInfo.processInfo.globallyUniqueString + ".png"
        self.getPreSignedURLRequest.bucket = "budgetcaddie"
        self.getPreSignedURLRequest.key = globalFileName
        self.getPreSignedURLRequest.httpMethod = .PUT
        self.getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)
        self.getPreSignedURLRequest.contentType = "image/png"
        
        // MARK: Get PreSigned URLRequest
        ServiceManager.sharedInstance.imageUploadGetPreSignedURLRequest(preSignedURL: self.getPreSignedURLRequest, viewController: viewController, fileURL: filePath, fileName: globalFileName, dimention: imageDimention, currentItem: 0, totalCount: 0, type: type) { (filename, statusCode) in
            if statusCode.rawValue == 200{
                completion(filename!,statusCode.rawValue)
            } else {
                print("error")
                completion("",statusCode.rawValue)
            }
        }
    }
    
    // MARK: To Upload Image to AWS
    func UploadImageToAWSWithoutAnimation(uploadImage: UIImage!,viewController: UIViewController!, completion: @escaping(_ uploadUrl: String, _ statusCode: Int) -> Void) {
        // MARK: create file path
        let filePath: URL = createFilePath(image: uploadImage)
        let globalFileName = ProcessInfo.processInfo.globallyUniqueString + ".png"
        self.getPreSignedURLRequest.bucket = "budgetcaddie"
        self.getPreSignedURLRequest.key = globalFileName
        self.getPreSignedURLRequest.httpMethod = .PUT
        self.getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)
        self.getPreSignedURLRequest.contentType = "image/png"
        
        // MARK: Get PreSigned URLRequest
        ServiceManager.sharedInstance.imageUploadGetPreSignedURLRequestWithoutLoader(preSignedURL: self.getPreSignedURLRequest, viewController: viewController, fileURL: filePath, fileName: globalFileName, dimention: imageDimention, currentItem: 0, totalCount: 0) { (filename, statusCode) in
            if statusCode.rawValue == 200{
                completion(filename!,statusCode.rawValue)
            } else {
                print("error")
                completion("",statusCode.rawValue)
            }
        }
    }
    
    func createFilePath(image: UIImage) -> URL {
        // MARK: create file directory
        let docDir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageUniqueName : Int64 = Int64(NSDate().timeIntervalSince1970 * 1000)
        if let filePath = docDir?.appendingPathComponent("\(imageUniqueName).png") {
            do {
                // MARK: compress image & save to specific filepath
                if let compressImage = image.wxCompress().jpegData(compressionQuality: .greatestFiniteMagnitude) {
                    try compressImage.write(to: filePath, options : .atomic)
                    return filePath
                }
            } catch {
                print("couldn't write image")
            }
        }
        return URL.init(string: "")!
    }
}
