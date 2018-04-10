//
//  SessionManager.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/10/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//

import Foundation
import UIKit

class SessionManager {

    // MARK: - Accessing

    static var shared = SessionManager()
    fileprivate let apiUrl = "https://www.reddit.com/"

    // MARK: - Requests

    func fetchTopListings(limit: Int = 50, completionHandler: @escaping ([Listing]?) -> Void) {
        let urlString = self.apiUrl + "top/.json?limit=\(limit)"
        guard let url = URL(string: urlString) else { return }

        let session = URLSession.shared
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: GET \(urlString)")
                print(error.debugDescription)
                completionHandler(nil)
                return
            }

            guard let data = data else {
                print("Error: No data - GET \(urlString)")
                return
            }

            let jsonDecoder = JSONDecoder()

            do {
                let listings = try jsonDecoder.decode(TopListingsResponse.self, from: data)
                completionHandler(listings.data.listings)
            } catch let error {
                print("Error: Json - GET \(urlString)")
                print(error.localizedDescription)
                completionHandler(nil)
                return
            }
        }
        task.resume()
    }

}
