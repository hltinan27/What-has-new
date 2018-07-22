//
//  ViewController.swift
//  ProjectForNeyasis
//
//  Created by inan on 20.07.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

  @IBOutlet weak var backgrounImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    let swipeGestureRec = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
    swipeGestureRec.direction = [.left,.right]
    self.view.addGestureRecognizer(swipeGestureRec)
  
  }
  
  @objc func swipe(_ gesture: UISwipeGestureRecognizer){
    
    UserDefaults.standard.set(true, forKey: "status")
    UserDefaults.standard.synchronize()
    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    delegate.introduction()
    
    //let vc = storyboard?.instantiateViewController(withIdentifier: "tabBar")
    //present(vc!, animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
}

