//
//  CategoryTableViewController.swift
//  ProjectForNeyasis
//
//  Created by inan on 21.07.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

  let categoryBlogURL = "https://newsapi.org/v2/sources?apiKey=4fca2485d59a4602ab4ac76f292d6a72"
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  var categories = [Category]()
  var selectedCategory = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        connectURL()
      
      self.navigationItem.title = "News"
      
      tableView.separatorStyle = .none
      
      activityIndicator.center = self.view.center
      activityIndicator.hidesWhenStopped = true
      activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
      view.addSubview(activityIndicator)
      
      activityIndicator.startAnimating()

    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
  

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCel", for: indexPath) as! CategoryTableViewCell

         cell.categoryNameLabel.text = categories[indexPath.row].name

        return cell
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    selectedCategory = categories[indexPath.row].name!
    performSegue(withIdentifier: "showNews", sender: nil)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showNews"{
      
      let destinationVC = segue.destination as? BlogViewController
      destinationVC?.categoryName = selectedCategory
      
    }
  }
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    activityIndicator.stopAnimating()
  }
  
  // MARK: Network
  
  func connectURL(){
    guard let url = URL(string: categoryBlogURL) else {
      print("url error")
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else {
        return
      }
      
      do{
        let news = try JSONDecoder().decode(NewsCategoryJsonStuff.self, from: data)
        self.categories = news.sources
        
        DispatchQueue.main.sync {
          self.tableView.reloadData()
          self.tableView.separatorStyle = .singleLine
        }
      }catch{
        print(error.localizedDescription)
        
      }
      
      }.resume()
    
  }


}
