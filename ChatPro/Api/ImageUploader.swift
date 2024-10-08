//
//  ImageUploader.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 8.10.24.
//

import FirebaseStorage
import UIKit

struct ImageUploader {
    static func uploadImage(image: UIImage, folderName: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw NSError(domain: "ImageUploaderError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])
        }
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/\(folderName)/\(filename)")
        
        do {
            _ = try await ref.putDataAsync(imageData, metadata: nil)
        } catch {
            throw NSError(domain: "ImageUploaderError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to upload image: \(error.localizedDescription)"])
        }
        
        do {
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            throw NSError(domain: "ImageUploaderError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve image URL: \(error.localizedDescription)"])
        }
    }
}
