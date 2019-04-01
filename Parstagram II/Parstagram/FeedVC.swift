//
//  FeedVC.swift
//  Parstagram
//
//  Created by SAURAV on 3/20/19.
//  Copyright © 2019 SAURAV. All rights reserved.

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {

  var posts = [PFObject]()
//  var comments = [PFObject]()
  let commentBar = MessageInputBar()
  var showcommentBar = false
  var selectedPost: PFObject!
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()

    commentBar.inputTextView.placeholder = "Add a comment..."
    commentBar.sendButton.title = "Post"
    commentBar.delegate = self
    
    // Do any additional setup after loading the view.
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.keyboardDismissMode = .interactive // Scrolling dismisses kb
//      self.tableView.rowHeight = 44;
    
    let center = NotificationCenter.default
    center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String){
    // Create the comment
    let comment = PFObject(className: "Comments")
    comment["text"] = text // "Post the comment"
    comment["post"] = selectedPost
    comment["author"] = PFUser.current()

    selectedPost.add(comment, forKey: "comments")
    
    selectedPost.saveInBackground{ (success,error) in
      if success{ print("Comment saved!") }
      else{ print("Error in saving") }
    }
    
    tableView.reloadData()
    // Clear and dismiss the input bar
    commentBar.inputTextView.text = nil
    showcommentBar = false
    becomeFirstResponder()
    commentBar.inputTextView.resignFirstResponder()
  }
  
  @objc func keyboardWillBeHidden(note:Notification){
    commentBar.inputTextView.text = nil
    showcommentBar = false
    becomeFirstResponder()
  }
  
  override var inputAccessoryView: UIView?{
    return commentBar
  }
  
  override var canBecomeFirstResponder: Bool{
    return showcommentBar
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let query = PFQuery(className: "Posts") // name of table
//    query.includeKey("author")
    query.includeKeys(["author", "comments", "comments.author"])
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
    let post = posts[section]
    let comments = (post["comments"] as? [PFObject]) ?? [] // If left value is nil, use right value []
    
    return comments.count + 2
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let post = posts[indexPath.section]
    let comments = (post["comments"] as? [PFObject]) ?? []
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "PostTVC") as! PostTVC //post view cell
      
      let user = post["author"] as! PFUser
      cell.username.text = user.username
      cell.caption.text = post["caption"] as? String
      
      let image = post["image"] as! PFFileObject
      let urlStr = image.url!
      let url = URL(string: urlStr)!
      cell.photo.af_setImage(withURL: url)
      return cell
    } else if indexPath.row <= comments.count {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVC") as! CommentTVC
      
      let comment = comments[indexPath.row - 1]
      cell.comment.text = comment["text"] as? String

      let user = comment["author"] as! PFUser
      cell.name.text = user.username
      return cell
    } else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
      return cell
    }
    
  }
  
  @IBAction func onLogout(_ sender: Any) {
    PFUser.logOut()
    let main = UIStoryboard(name: "Main", bundle: nil)
    
    let login = main.instantiateViewController(withIdentifier: "LoginVC") // put Login View Controller to go back
    let delegate = UIApplication.shared.delegate as! AppDelegate
    delegate.window?.rootViewController = login
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let post = posts[indexPath.section] // post is the tableCell we selected
//    let comment = PFObject(className: "Comments")
    let comments = (post["comments"] as? [PFObject]) ?? []
//
    if indexPath.row == comments.count + 1{
      showcommentBar = true
      becomeFirstResponder()
      commentBar.inputTextView.becomeFirstResponder()
      selectedPost = post
    }
    
    
//    comment["text"] = "Post the comment"
//    comment["post"] = post
//    comment["author"] = PFUser.current()
//
//    post.add(comment, forKey: "comments")
//
//    post.saveInBackground{ (success,error) in
//      if success{ print("Comment saved!") }
//      else{ print("Error in saving") }
//    }
  }
  
}
