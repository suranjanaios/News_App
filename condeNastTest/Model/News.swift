//
//  News.swift
//  condeNastTest
//
//  Created by suranjana on 31/07/20.
//  Copyright © 2020 suranjana. All rights reserved.
//

import Foundation
struct  News : Codable {
    
    var id : String
    var name :String?
    var author : String?
    var title : String?
    var description : String?
    var url : String?
    var urlToImage : String?
    var publishedAt : String?
    var content : String?
    
    private enum rootKeys : String , CodingKey{
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
   
    private enum sourceDictKeys : String , CodingKey{
        case id
        case name
    }
    // MARK: Coding Keys

     init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: rootKeys.self)
        
       
        let sourceContainer = try container.nestedContainer(keyedBy: sourceDictKeys.self, forKey: .source)
        if let newdId = try sourceContainer.decodeIfPresent(String.self, forKey: .id){
            
            id = newdId
            
        } else if let newdId = try sourceContainer.decodeIfPresent(Int.self, forKey: .id){
            
            id = String(newdId)
            
        }
        else {
            id = "NA"
            
        }
       if let nameStr = try sourceContainer.decodeIfPresent(String.self, forKey: .name){
           name = nameStr
           
       } else {
           name = "NA"
       } 

        if let authorStr = try container.decodeIfPresent(String.self, forKey: .author){
            author = authorStr
            
        } else {
            author = "NA"
        }
        
        if let titleStr = try container.decodeIfPresent(String.self, forKey: .title){
            title = titleStr
            
        } else {
            title = "NA"
        }
        
        if let descriptionStr = try container.decodeIfPresent(String.self, forKey: .description){
            description = descriptionStr
            
        } else {
            description = "NA"
        }
        if let urlStr = try container.decodeIfPresent(String.self, forKey: .url){
            url = urlStr
            
        } else {
            url = "NA"
        }
        if let urlToImageStr = try container.decodeIfPresent(String.self, forKey: .urlToImage){
            urlToImage = urlToImageStr
            
        } else {
            urlToImage = "NA"
        }
        if let publishedAtStr = try container.decodeIfPresent(String.self, forKey: .publishedAt){
            publishedAt = publishedAtStr
            
        } else {
            publishedAt = "NA"
        }
        if let contentStr = try container.decodeIfPresent(String.self, forKey: .content){
            content = contentStr
            
        } else {
            content = "NA"
        }
        
    }
    
}
struct articles : Codable {
    let results: [News]
}

