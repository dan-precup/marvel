//
//  LoadingNotifier.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Combine
import Foundation

protocol LoadingNotifier {

    /// Flag to notify the loading state
    var isLoading: CurrentValueSubject<Bool, Never> { get }
}
