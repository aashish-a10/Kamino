//
//  PlanetViewModel.swift
//

import RxSwift
import RxCocoa

public class PlanetViewModel: ViewModel {
    
    // MARK: Private Properties
    private var planet: Planet
    private let planetRepository: PlanetRepositoryProtocol
    private let navigationResponder: GoToResidentsNavigator
    
    private(set) public var planetDetails = BehaviorRelay<[(String, String)]>(value: [])
    public let title: String
    public let id: Int
    
    // MARK: Properties
    public let likeButtonEnabled = BehaviorSubject<Bool>(value: true)
    public let imageDataInput = BehaviorSubject<Data?>(value: nil)
    
    // MARK: Initializer
    public init(planet: Planet,
                planetRepository: PlanetRepositoryProtocol,
                navigationResponder: GoToResidentsNavigator) {
        self.planet = planet
        self.planetRepository = planetRepository
        self.title = planet.name
        self.id = Planet.id
        self.navigationResponder = navigationResponder
        
        super.init()
        setupPlanetDetails()
    }
    
    // MARK: Public Methods
    public func downloadImage() {
        indicateLoading(true)
        
        planetRepository.downloadImage(urlString: planet.imageUrl) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.imageDataInput.onNext(data)
            case .failure(let error):
                self.indicateErrorInLoading(error)
            }
            self.indicateLoading(false)
        }
    }
    
    @objc
    public func likePlanet(forId: Int) {
        indicateLoading(true)
        
        planetRepository.likePlanet(forId: forId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.likeButtonEnabled.onNext(false)
                self.indicateLoading(false)
                
            case .failure(let error):
                self.indicateErrorInLoading(error)
            }
        }
    }
    
    public func showResident() {
        navigationResponder.navigateToResidents()
    }
    
    // MARK: Private Methods
    private func setupPlanetDetails() {
        let details = [(Constants.Planet.name, planet.name),
                       (Constants.Planet.likes, planet.like.count),
                       (Constants.Planet.rotationPeriod, planet.rotationPeriod),
                       (Constants.Planet.residents, planet.residentsCount),
                       (Constants.Planet.orbitalPeriod, planet.orbitalPeriod),
                       (Constants.Planet.diameter, planet.diameter),
                       (Constants.Planet.climate, planet.climate),
                       (Constants.Planet.gravity, planet.gravity),
                       (Constants.Planet.terrain, planet.terrain),
                       (Constants.Planet.surfaceWater, planet.surfaceWater),
                       (Constants.Planet.population, planet.population)]
        planetDetails.accept(details)
    }
    
    private func indicateLoading(_ loading: Bool) {
        isLoading.onNext(loading)
    }
    
    private func indicateErrorInLoading(_ error: Error?) {
        errorMessageSubject.onNext(
            ErrorMessage(title: Constants.Error.title, message: error?.localizedDescription ?? Constants.Error.messages)
        )
        indicateLoading(false)
    }
}
