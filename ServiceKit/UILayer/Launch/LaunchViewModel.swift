//
//  PlanetViewModel.swift
//

import RxSwift

public protocol FetchedPlanetResponder {
    func fetched(planet: Planet)
}

public class LaunchViewModel: ViewModel {
    
    // MARK: Private Properties
    private let planetRepository: PlanetRepositoryProtocol
    private let fetchedPlanetResponder: FetchedPlanetResponder
    
    // MARK: Initializer
    public init(planetRepository: PlanetRepositoryProtocol,
                fetchedPlanetResponder: FetchedPlanetResponder) {
        self.planetRepository = planetRepository
        self.fetchedPlanetResponder = fetchedPlanetResponder
    }
    
    // MARK: Public Methods
    @objc
    public func fetchPlanet(forId: Int) {
        indicateLoading()
        planetRepository.fetchPlanetDetails(forId: forId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let planet):
                self.fetchedPlanetResponder.fetched(planet: planet)
            case .failure(let error):
                self.indicateErrorInLoading(error)
            }
        }
    }
    
    // MARK: Private Methods
    private func indicateLoading() {
        isLoading.onNext(true)
    }
    
    private func indicateErrorInLoading(_ error: Error?) {
        errorMessageSubject.onNext(
            ErrorMessage(title: Constants.Error.title, message: error?.localizedDescription ?? Constants.Error.messages)
        )
        isLoading.onNext(true)
    }
}
