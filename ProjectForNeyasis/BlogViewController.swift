//
//  BlogViewController.swift
//  ProjectForNeyasis
//
//  Created by inan on 21.07.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

var cacheImages = NSCache<AnyObject, AnyObject>()

 class BlogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!
 
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  var newsArray = [NewsArticleArray]()
  var showNews = [NewsArticleArray]()
  var firstnews = 10
  var lastnews = 19
  var categoryName: String = "" {
    didSet{
        connectURL()
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.separatorStyle = .none
        tableView.separatorStyle = .singleLine
        // Row Heightlerin ortalama yükseklik
        tableView.estimatedRowHeight = 185
      
      
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
     

    }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    activityIndicator.startAnimating()
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return showNews.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
   let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell", for: indexPath) as! BlogTableViewCell
    cell.blogTitle.text = showNews[indexPath.row].title
    cell.blogNews.text = showNews[indexPath.row].description
    cell.blogImageView.downloadImage(from: showNews[indexPath.row].urlToImage!)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 170
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
   activityIndicator.stopAnimating()
   let lastItem = showNews.count - 1
    if indexPath.row == lastItem{
      addingPartOfNews()
    }
  }
  
  // Add new 10 cell
  func addingPartOfNews(){
    if lastnews <= newsArray.count - 1 {
    for index in firstnews...lastnews {
      showNews.append(newsArray[index])
    }
    tableView.reloadData()
    firstnews += 10
    lastnews += 10
    }
  }
  

  // MARK: Network
  
  func connectURL(){
    let convertName = categoryName.replacingOccurrences(of: " ", with: "-")
    let blogURL = "https://newsapi.org/v2/everything?sources=\(convertName)&apiKey=4fca2485d59a4602ab4ac76f292d6a72"
    print("blog URLLLLLLLL: \(blogURL)")
    guard let url = URL(string: blogURL) else {
      print("url error")
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else {
        return
      }
      
      do{
        let news = try JSONDecoder().decode(NewsJsonStuff.self, from: data)
        for new in news.articles {
          if new.urlToImage != nil{
            self.newsArray.append(new)
          }
        }
        if self.newsArray.count >= 10 {
          self.showNews = Array(self.newsArray[0...9])
        }else{
          self.showNews = self.newsArray
        }
        
       
        DispatchQueue.main.sync {
          self.tableView.reloadData()
        }
      }catch{
        print(error.localizedDescription)
        print("errrrrrrrr")
      }
      
    }.resume()
    
  }
 

}

extension UIImageView {
  func downloadImage(from getUrl: String){
    
    if let cacheImage = cacheImages.object(forKey: getUrl as AnyObject){
      self.image = cacheImage as! UIImage
    }else{
      guard let url = URL(string: getUrl) else {
        print("Image URL error")
        return
      }
      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else{
          print("data error")
          return
        }
        if let image = UIImage(data: data){
           cacheImages.setObject(image, forKey: getUrl as AnyObject)
          DispatchQueue.main.async {
            self.image = image
            
          }
        }else{
          self.image = UIImage(named: "mark")
        }
       
        
      };task.resume()
    }
    
    
  }
}

  

