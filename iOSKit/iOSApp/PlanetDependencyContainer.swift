//
//  PlanetDependencyContainer.swift
//

import Foundation
import CommonKit
import ServiceKit

public class PlanetDependencyContainer {
    
    // MARK: - Private Properties
    private let planet: Planet
    private(set) var planetRepository: PlanetRepositoryProtocol
    private let rootViewModel: RootViewModel
    
    private let sharedNavigationViewModel: PlanetNavigationViewModel
    
    // MARK: Initializer
    public init(planet: Planet, appDependencyContainer: AppDependencyContainer) {
        
        func makePlanetNavigationViewModel() -> PlanetNavigationViewModel {
            return PlanetNavigationViewModel()
        }
        
        self.planet = planet
        self.planetRepository = appDependencyContainer.sharedPlanetRepository
        self.rootViewModel = appDependencyContainer.sharedRootViewModel
        self.sharedNavigationViewModel = makePlanetNavigationViewModel()
    }
    
    // MARK: Factory Methods
    public func makePlanetNavigationViewController() -> PlanetNavigationViewController {
        let planetViewController = makePlanetViewController()
        let residentsViewController = makeResidentsViewController()
        
        let residentDetailViewControllerFactory = { (resident: Resident) in
            return self.makeResidentDetailViewController(resident: resident)
        }
        
        return PlanetNavigationViewController(viewModel: sharedNavigationViewModel,
                                              planetViewController: planetViewController,
                                              residentsViewController: residentsViewController,
                                              residentDetailControllerFactory: residentDetailViewControllerFactory)
    }
    
    public func makePlanetViewController() -> PlanetViewController {
        return PlanetViewController(viewModelFactory: self)
    }
    
    public func makeResidentsViewController() -> ResidentsViewController {
        return ResidentsViewController(viewModelFactory: self)
    }
    
    public func makeResidentDetailViewController(resident: Resident) -> ResidentDetailViewController {
        let dependencyContainer = makeResidentDependencyContainer(resident: resident)
        return dependencyContainer.makeResidentDetailViewController()
    }
    
    public func makeResidentDependencyContainer(resident: Resident) -> ResidentDependencyContainer {
        return ResidentDependencyContainer(resident: resident, appDependencyContainer: self)
    }
}

extension PlanetDependencyContainer: PlanetViewModelFactory, ResidentsViewModelFactory {
    
    public func makeResidentsViewModel() -> ResidentsViewModel {
        return ResidentsViewModel(residents: planet.residents,
                                  planetRepository: planetRepository,
                                  navigationResponder: sharedNavigationViewModel)
    }
    
    public func makePlanetViewModel() -> PlanetViewModel {
        return PlanetViewModel(planet: planet,
                               planetRepository: planetRepository,
                               navigationResponder: sharedNavigationViewModel)
    }
}

