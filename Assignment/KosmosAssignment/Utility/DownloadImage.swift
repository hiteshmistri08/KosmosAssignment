//
//  DownloadImage.swift
//  KosmosAssignment
//
//  Created by Hitesh on 25/03/21.
//

import UIKit

final class DownloadImage {
        
    private init() {}
    
    static func loadImage(
        url: URL,completion: ((UIImage?, Error?) -> Void)? = nil)  {
        
        // Determine the cached file path of the remote url
        let cachedFile = FileManager.default.temporaryDirectory
            .appendingPathComponent(
                url.lastPathComponent,
                isDirectory: false
            )
        
        // If the image exists in the cache,
        // load the image from the cache and exit
        if let image = UIImage(contentsOfFile: cachedFile.path) {
//            self.image = image
            completion?(image,nil)
            return
        }
        
        // If the image does not exist in the cache,
        // download the image to the cache
        DownloadImage.download(url: url, toFile: cachedFile) { (error) in
            let image = UIImage(contentsOfFile: cachedFile.path)
            DispatchQueue.main.async {
//                self.image = image
                completion?(image,error)
            }
        }
    }
    
    private static func download(
        url: URL,
        toFile file: URL,
        completion: @escaping (Error?) -> Void) {
        
        // Download the remote URL to a file
        let task = URLSession.shared.downloadTask(with: url) {
            (tempURL, response, error) in
            // Early exit on error
            guard let tempURL = tempURL else {
                completion(error)
                return
            }
            
            do {
                // Remove any existing document at file
                if FileManager.default.fileExists(atPath: file.path) {
                    try FileManager.default.removeItem(at: file)
                }
                
                // Copy the tempURL to file
                try FileManager.default.copyItem(
                    at: tempURL,
                    to: file
                )
                
                completion(nil)
            }
            // Handle potential file system errors
            catch _ {
                completion(error)
            }
        }
        
        // Start the download
        task.resume()
    }
    
}
