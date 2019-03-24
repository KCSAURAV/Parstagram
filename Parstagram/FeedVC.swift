//
//  FeedVC.swift
//  Parstagram
//
//  Created by SAURAV on 3/20/19.
//  Copyright © 2019 SAURAV. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

  var posts = [PFObject]()
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
      super.viewDidLoad()

        // Do any additional setup after loading the view.
      tableView.delegate = self
      tableView.dataSource = self
//      self.tableView.rowHeight = 44;
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let query = PFQuery(className: "Posts")
    query.includeKey("author")
    query.limit = 20
    query.findObjectsInBackground{ (posts,error) in
      if posts != nil {
        self.posts = posts!
        self.tableView.reloadData()
      }
    }
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let post = posts[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostTVC") as! PostTVC //post view cell
    
    let user = post["author"] as! PFUser
    cell.username.text = user.username
    cell.caption.text = post["caption"] as! String
    
    let image = post["image"] as! PFFileObject
    let urlStr = image.url!
    let url = URL(string: urlStr)!
    cell.photo.af_setImage(withURL: url)
    return cell
  }
}
