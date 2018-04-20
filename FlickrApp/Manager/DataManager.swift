//
//  DataManager.swift
//  FlickrApp
//
//  Created by Jacob Ahlberg on 2018-04-18.
//  Copyright © 2018 Jacob Ahlberg. All rights reserved.
//

import UIKit

class DataManager {
    static var shared = DataManager()
    
    let apiKey = "3a7625abba0d1969ba147d88ba176c68"
    let secret = "47a82f4c906a689f"
    
    let flickUrlBase = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
    let apiUrl = "&api_key="
    let inputSearchTextUrl = "&text="
    let formatUrl = "&format=json&nojsoncallback=1"
    
    func searchImages(searchedText text: String, completion: @escaping (_ photos: [Photo]?, _ error: Error?) -> ()) {
        let fullUrl = flickUrlBase + apiUrl + apiKey + inputSearchTextUrl + text + formatUrl
        guard let url = URL(string: fullUrl) else { return }
        var photoArray: [Photo] = []
        
        do {
            let jsonData = try Data.init(contentsOf: url)
            if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSDictionary {
                guard let photosJson = jsonResult.object(forKey: "photos") as? NSDictionary else { return }
                guard let photos = photosJson.object(forKey: "photo") as? NSArray else { return }
                for photo in photos {
                    if let photo = photo as? NSDictionary {
                        guard let id = photo["id"] as? String,
                            let secret = photo["secret"] as? String,
                            let farm = photo["farm"] as? Int,
                            let serverId = photo["server"] as? String,
                            let title = photo["title"] as? String
                            else {
                                continue
                        }
                        
                        let newPhoto = Photo(id: id, secret: secret, serverId: serverId, farm: farm, title: title)
                        photoArray.append(newPhoto)
                    }
                }
                completion(photoArray, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    func downloadImages(_ photos: [Photo], completion: @escaping (_ downloadedPhotos: [Photo]?,_ error: Error?) -> ()) {
        DispatchQueue.main.async {
            var imageUrlArray: [String] = []
            for photo in photos {
                guard let id = photo.id,
                    let farm = photo.farm,
                    let server = photo.serverId,
                    let secret = photo.secret
                    else {
                        continue
                }
                let newUrl = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
                imageUrlArray.append(newUrl)
            }
            
            for (index, imageUrl) in imageUrlArray.enumerated() {
                guard let url = URL(string: imageUrl) else { return }
                do {
                    let imageData = try Data.init(contentsOf: url)
                    let image = UIImage(data: imageData)
                    photos[index].thumbNail = image
                } catch {
                    print(error.localizedDescription)
                }
            }
            completion(photos, nil)
        }
    }
}
