//
//  PostsViewController.swift
//  Post It
//
//  Created by Erik Ugarte on 2020-09-02.
//  Copyright © 2020 Creative League. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var postTableView: UITableView!
    
    // MARK: Constants
    let cellIdentifier = "ReusableCell"
    let cellId = "Cell"
    
    // MARK: Variables
    var posts: [Post] = []
    
    // MARK: Functions
    // Returning the number of rows in the from the "posts" array for the PostTableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    // Creating each TableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].message
        return cell
    }
    
    // MARK: Main
    override func viewDidLoad() {
        super.viewDidLoad()
        // Creating the Nib for the custom TableViewCell in the PostTableView
        let Nib = UINib(nibName: "TableViewCell", bundle: nil)
        postTableView.register(Nib, forCellReuseIdentifier: cellId)
        postTableView.dataSource = self
        postTableView.delegate = self
        
        // Fetching the posts from the user and saving them in the "posts" array
        if let token = AccessToken.current, !token.isExpired {
            let token = token.tokenString

            let request = FBSDKLoginKit.GraphRequest(graphPath: "me/feed/?fields=message,created_time", parameters: ["data": "message, created_time"], tokenString: token, version: nil, httpMethod: .get) // <-- GET REQUEST
            request.start(completionHandler: {connection, result, error in
                // Re-structure the JSON data as an array containing NSDict
                if let jsonData = result as? [String: Any], let data = jsonData["data"] as? Any, let JSONArray = data as? Array<Any>{
                    // Iterate over the JSONarray
                    for element in JSONArray {
                        do {
                            // Decode each NSDict element in the data
                            let jsonData = try JSONSerialization.data(withJSONObject: element, options: .prettyPrinted)
                            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                            if let dictFromJSON = decoded as? [String:String] {
                                
                                // Create Post object
                                let post: Post = Post(message: dictFromJSON["message"], date: dictFromJSON["created_time"]!, id: dictFromJSON["id"]!)
                                
                                // Append Post object to the postArray for display in the postTableView if the message element exists
                                if post.message != " " {
                                    self.posts.append(post)
                                }
                                
                                // Update the postTableView
                                DispatchQueue.main.async {
                                    self.postTableView.reloadData()
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    print(error.debugDescription)
                }
            })
        } else {
            print("Unsuccessful request")
        }
    }
}
