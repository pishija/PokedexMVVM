//
//  LikeStatusResource.swift
//  PokemonApi
//
//  Created by Mihail Stevcev on 21/05/2024.
//

import Foundation


struct LikeStatusResource: APIResource {
    typealias ModelType = WebHookModel
    typealias Payload = LikePokemonPayload
    
    let name: String
        
    var methodPath: String = ""
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var method: String {
        return "GET"
    }
    
    var url: URL {
        return URL(string: "https://webhook.site/token/1e12550f-63bf-4017-b3bd-c086f9baee2e/requests?sorting=newest&query=content:\(name)")!
    }
}


struct WebHookModel: Codable {
    var total: Int
}
