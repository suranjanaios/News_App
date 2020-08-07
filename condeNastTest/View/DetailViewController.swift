//
//  DetailViewController.swift
//  condeNastTest
//
//  Created by suranjana on 01/08/20.
//  Copyright © 2020 suranjana. All rights reserved.
//

import UIKit
import Reachability
import MBProgressHUD
class DetailViewController: UIViewController {
    var newsDetailObj:NewsViewModel? = nil
    var reachability: Reachability?
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    
    @IBOutlet weak var publishedAt: UILabel!
    @IBOutlet weak var titleLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var authorLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nameLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var descHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var totalLikeCount : Int? = 0
    var totalCommentCount : Int? = 0
    
    // MARK: life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "News Detail"
        do {
            try reachability = Reachability()
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
            try reachability?.startNotifier()
        } catch {
            print("This is not working.")
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: API call method
    func fetchDetails(){
       
        var likeUrl : String = ""
        var commentUrl : String = ""
        
        if var articleID = newsDetailObj?.url {
            
            if articleID.contains("http://") {
                articleID = articleID.replacingOccurrences(of: "http://", with: "")
                
                
            } else if articleID.contains("https://") {
                articleID = articleID.replacingOccurrences(of: "https://", with: "")
                
            }
            
            
            if articleID.contains("/") {
                articleID = articleID.replacingOccurrences(of: "/", with: "-")
                
                if articleID.last! == "-"{
                    articleID.remove(at: articleID.index(before: articleID.endIndex))
                }
            }
            
            likeUrl = GlobalConstant.likeUrl+articleID
            commentUrl = GlobalConstant.commentUrl+articleID
            
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.main.async {
                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                loadingNotification.label.text = "Loading..."
            }
            DispatchQueue.global().async {
                
                webServiceManager.shared.makeRequestLike(urlStr: likeUrl){ like,error  in
                    
                    if let err = error {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.showAlert(str: err.localizedDescription)
                         
                    } else{
                        self.totalLikeCount = like?.likes
                     }
                    group.leave()
                    
                }
                
                
            }
            
            group.enter()
            DispatchQueue.global().async {
                
                webServiceManager.shared.makeRequestComment(urlStr: commentUrl){ comment,error in
                    if let err = error {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.showAlert(str: err.localizedDescription)
                         
                    } else{
                        self.totalCommentCount = comment?.comments
                        
                    }
                    group.leave()
                }
                
                
            }
            
            group.notify(queue: DispatchQueue.main) {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showDetail()
            }
        }
        
    }
    
    
    // MARK: Alert method
    func showAlert(str:String){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        let alert = UIAlertController(title: "Alert", message: str,preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:  method for dynamic height
    func setDynamicTextViewHeight(){
        
        let fixedWidthContent = contentTextView.frame.size.width
        let newSize = contentTextView.sizeThatFits(CGSize(width: fixedWidthContent, height: CGFloat.greatestFiniteMagnitude))
        contentHeight.constant = newSize.height
        
        let fixedWidthDesc = descTextView.frame.size.width
        let newSizeDesc = descTextView.sizeThatFits(CGSize(width: fixedWidthDesc, height: CGFloat.greatestFiniteMagnitude))
        descHeight.constant = newSizeDesc.height
        
        
        let fixedWidthTitle = titleLbl.frame.size.width
        let newSizeTitle = titleLbl.sizeThatFits(CGSize(width: fixedWidthTitle, height: CGFloat.greatestFiniteMagnitude))
        titleLblHeight.constant = newSizeTitle.height
        
        
        let fixedWidthName = nameLbl.frame.size.width
        let newSizeName = nameLbl.sizeThatFits(CGSize(width: fixedWidthName, height: CGFloat.greatestFiniteMagnitude))
        nameLblHeight.constant = newSizeName.height
        
        let fixedWidthauthor = nameLbl.frame.size.width
        let newSizeAuthor = authorLbl.sizeThatFits(CGSize(width: fixedWidthauthor, height: CGFloat.greatestFiniteMagnitude))
        authorLblHeight.constant = newSizeAuthor.height
        
    }
    // MARK: populate UI method
    func showDetail(){
        
        self.likeCount.text = "Likes : \(self.totalLikeCount!)"
        self.commentCount.text = "Comments : \(self.totalCommentCount!)"
        self.newsImg?.image = UIImage(named: "images.jpeg")
        if let imageUrl = newsDetailObj?.urlToImage {
            self.newsImg?.sd_setImage(with: URL(string:imageUrl ) , placeholderImage: UIImage(named: "images.jpeg"))
        }
        self.authorLbl.text = "NA"
        if let authorStr = newsDetailObj?.author{
            self.authorLbl.text = "Author : " + authorStr
        }
        self.nameLbl.text = "NA"
        if let nameStr = newsDetailObj?.name{
            self.nameLbl.text = "Name : " + nameStr
        }
        //self.publishedAt.text = "NA"
        if let dateStr = newsDetailObj?.publishedAt{
        //print("dateStr====",dateStr)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: dateStr)
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            if let newDate = date{
                let date1 = dateFormatter.string(from: newDate)
                self.publishedAt.text = "Published at : " + date1
            }
        }
        
       
        self.descTextView.text = "NA"
        if let descStr = newsDetailObj?.desc{
            let descStr1  = descStr.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            self.descTextView.text = descStr1
        }
        
        self.contentTextView.text = "NA"
        if let contentStr = newsDetailObj?.content{
            let contentStr1  = contentStr.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            self.contentTextView.text = contentStr1
        }
        self.titleLbl.text = "NA"
        if let titleStr = newsDetailObj?.title{
            self.titleLbl.text = "Title : " + titleStr
        }
        
        self.setDynamicTextViewHeight()
    }
    
    // MARK: observer method
    @objc func reachabilityChanged(_ note: NSNotification) {
        if reachability?.connection == .wifi {
            print("Reachable via WiFi")
            self.fetchDetails()
        } else if reachability?.connection == .cellular{
            print("Reachable via Cellular")
            self.fetchDetails()
        }
        else {
            print("Not reachable")
            self.showAlert(str: "Please check your internet connection.")
        }
    }
}
