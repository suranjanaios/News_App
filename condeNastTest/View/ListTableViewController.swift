//
//  ListTableViewController.swift
//  condeNastTest
//
//  Created by suranjana on 07/08/20.
//  Copyright © 2020 suranjana. All rights reserved.
//

import UIKit

import SDWebImage
import MBProgressHUD
import Reachability
class ListTableViewController: UITableViewController {
    
    @IBOutlet weak var listTable: UITableView!
    var listModelObj :ListViewModel?
    var NewsListModels : [NewsViewModel]?
    var arr = [String]()
    var reachability: Reachability?
    
    
    // MARK: lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try reachability = Reachability()
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
            try reachability?.startNotifier()
        } catch {
            print("This is not working.")
        }
        self.navigationItem.title =  "News Listing"
        
        self.listTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "identifier")
        self.listTable.estimatedRowHeight = UITableView.automaticDimension
        self.listModelObj = ListViewModel()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: API call method
    func populateTable(){
        
        DispatchQueue.main.async {
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Loading..."
        }
        
        
        // setting up the bindings
        self.listModelObj?.bindToNewsList = {
            self.NewsListModels  = self.listModelObj?.NewsViewModels
            if let allModel = self.NewsListModels, allModel.count > 0 {
                self.listTable.reloadData()
                self.listTable.isHidden = false
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
            }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                let alert = UIAlertController(title: "Alert", message: "Error occurred. Please try again!",         preferredStyle: UIAlertController.Style.alert)
                
                
                alert.addAction(UIAlertAction(title: "Ok",
                                              style: UIAlertAction.Style.default,
                                              handler: {(_: UIAlertAction!) in
                                                //Sign out action
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        self.listModelObj?.showErrorAlert = { error in
                DispatchQueue.main.async {
                      MBProgressHUD.hide(for: self.view, animated: true)
                  }
                 let alert = UIAlertController(title: "Alert", message: error.localizedDescription,         preferredStyle: UIAlertController.Style.alert)
        
        
                  alert.addAction(UIAlertAction(title: "Ok",
                                                style: UIAlertAction.Style.default,
                                                handler: {(_: UIAlertAction!) in
                                                  //Sign out action
                  }))
                  self.present(alert, animated: true, completion: nil)
            
            }
        
    }
    
    // MARK: Alert method
    
    
    
    func showAlert(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        let alert = UIAlertController(title: "Alert", message: "Please check your internet connection.",         preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Observer method
    @objc func reachabilityChanged(_ note: NSNotification) {
        
        
        if reachability?.connection == .wifi {
            print("Reachable via WiFi")
            self.populateTable()
        } else if reachability?.connection == .cellular{
            print("Reachable via Cellular")
            self.populateTable()
        }
        else {
            print("Not reachable")
            self.showAlert()
        }
    }
    
}


extension ListTableViewController{
    public override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.NewsListModels?.count ?? 0
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath) as! TableViewCell
        let newsObj = self.NewsListModels?[indexPath.row]//listModelObj?.NewsViewModels?[indexPath.row]
        
        cell.authorLbl?.text = newsObj?.author
        let descStr  = newsObj?.desc?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        cell.descLbl?.text = descStr
        cell.imgVw?.image = UIImage(named: "images.jpeg")
        if let imageUrl = newsObj?.urlToImage {
            cell.imgVw?.sd_setImage(with: URL(string:imageUrl ) , placeholderImage: UIImage(named: "images.jpeg"))
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : DetailViewController = storyboard.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
        vc.newsDetailObj = self.NewsListModels?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
