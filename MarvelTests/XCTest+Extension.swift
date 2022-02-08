//
//  XCTest+Extension.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import Combine
import XCTest

extension XCTestCase {
    typealias CompetionResult = (expectation: XCTestExpectation, cancellable: AnyCancellable)
    
    func expectValue<T: Publisher>(of publisher: T,
                                       timeout: TimeInterval = 2,
                                       file: StaticString = #file,
                                       line: UInt = #line,
                                       equals: [T.Output]) -> CompetionResult where T.Output: Equatable {
      let exp = expectation(description: "Correct values of " + String(describing: publisher))
      var mutableEquals = equals
      let cancellable = publisher
        .sink(receiveCompletion: { _ in },
                   receiveValue: { value in
                     if value == mutableEquals.first {
                       mutableEquals.remove(at: 0)
                       if mutableEquals.isEmpty {
                         exp.fulfill()
                       }
                     }
                })
          return (exp, cancellable)
      }
}
