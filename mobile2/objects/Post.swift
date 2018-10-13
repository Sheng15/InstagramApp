//
//  Post.swift
//  mobile2
//
//  Created by Tianhang ZHANG on 11/10/18.
//  Copyright © 2018 LudwiG. All rights reserved.
//

import UIKit

class Post: NSObject {

    var author: String!
    var likes: Int!
    var photoUrl: String!
    var text: String!
    var userID: String!
    var postID: String!
    
    
    
    var peopleWhoLike: [String] = [String]()
    
    var likelist = [String]()
}
