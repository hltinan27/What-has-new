//
//  BlogDataModel.swift
//  ProjectForNeyasis
//
//  Created by inan on 21.07.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import Foundation
import UIKit

struct NewsJsonStuff: Codable {
  let articles: [NewsArticleArray]
}

struct NewsCategoryJsonStuff: Codable {
  let sources: [Category]
}

struct NewsArticleArray: Codable {
  let title: String?
  let description: String?
  let url: String?
  let urlToImage: String?
  
}

struct Category: Codable {
  let name: String?
}
