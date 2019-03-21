//
//  PostsTableViewController.swift
//  WhyiOS25
//
//  Created by Carson Buckley on 3/21/19.
//  Copyright © 2019 Launch. All rights reserved.
//

import UIKit

class PostsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    //Source of Truth <<<<<<<<<<<<<<<<<
    var fetchedPosts: [Post] = []
    
    var nameTextField = UITextField()
    var cohortTextField = UITextField()
    var reasonTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.refreshPosts()
    }
    
    func refreshPosts() {
        PostController.fetchPosts { (posts) in
            if let posts = posts {
                self.fetchedPosts = posts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        let post = fetchedPosts[indexPath.row]
        
        cell.nameLabel.text = post.name
        cell.cohortLabel.text = post.cohort
        cell.reasonLabel.text = post.reason
        
        return cell
    }
    
    
    
    
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        refreshPosts()
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let addPostAlertController = UIAlertController(title: "Add Your Reason", message: nil, preferredStyle: .alert)
        
        var nameTextField = UITextField()
        var cohortTextField = UITextField()
        var reasonTextField = UITextField()
        
        addPostAlertController.addTextField { (textfield) in
            nameTextField = textfield
            nameTextField.placeholder = "Enter your name..."
        }
        
        addPostAlertController.addTextField { (textfield) in
            cohortTextField = textfield
            cohortTextField.placeholder = "Enter your cohort..."
        }
        
        addPostAlertController.addTextField { (textfield) in
            reasonTextField = textfield
            reasonTextField.placeholder = "Enter the reason you chose iOS..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addPostAlertController.addAction(cancelAction)
        
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let name = nameTextField.text, !name.isEmpty,
                let reason = reasonTextField.text, !reason.isEmpty,
                let cohort = cohortTextField.text, !cohort.isEmpty else { return }
            PostController.postReason(name: name, cohort: cohort, reason: reason, completion: { (success) in
                if success {
                    self.refreshPosts()
                }
            })
        }
        addPostAlertController.addAction(postAction)
        
        self.present(addPostAlertController, animated: true, completion: nil)
        
    }
    
}
