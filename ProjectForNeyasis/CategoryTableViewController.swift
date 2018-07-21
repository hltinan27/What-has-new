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
  var categories = [Category]()
  var selectedCategory = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        connectURL()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        }
      }catch{
        print(error.localizedDescription)
        print("errrrrrrrr")
      }
      
      }.resume()
    
  }


}
