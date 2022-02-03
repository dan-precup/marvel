//
//  BaseViewModel.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Combine
import Foundation

class BaseViewModel: NSObject, LoadingNotifier {
    let isLoading = CurrentValueSubject<Bool, Never>(false)

    var errorMessage = PassthroughSubject<String?, Never>()
    var bag = Set<AnyCancellable>()

    func handlerCompletion(_ completion: Subscribers.Completion<Error>) {
        if case .failure(let error) = completion {
            errorMessage.send("Something went wrong, please try again later.")
            Log.error("Publisher completion error: \(error.localizedDescription)", error)
            isLoading.value = false
        }
    }
    
    func handlePublisher<T>(_ publisher: AnyPublisher<T, Error>, completion: @escaping (T) -> Void ) {
        handlePublisherWithoutStoring(publisher, completion: completion)
            .store(in: &bag)
    }
    
    func handlePublisherWithoutStoring<T>(_ publisher: AnyPublisher<T, Error>, completion: @escaping (T) -> Void ) -> AnyCancellable {
        return publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] comp in
                self?.handlerCompletion(comp)
            }, receiveValue: completion)
    }
}
