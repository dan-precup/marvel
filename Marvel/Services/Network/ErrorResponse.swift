//
//  ErrorResponse.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation

struct ErrorResponse: Error, Decodable {
    let code: String
    let message: String
}
