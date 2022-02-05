//
//  ImageResource.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation

struct ImageResource: Codable {
    let path: URL
    let fileExtension: String
    var url: URL { path.appendingPathExtension(fileExtension) }
    
    enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
}
