//
//  AppDependencyContainer.swift
//

import ServiceKit
import RxSwift

public class AppDependencyContainer {
    
    // MARK: - Properties
    let sharedPlanetRepository: PlanetRepositoryProtocol
    let sharedRootViewModel: RootViewModel
    
    // MARK: Initializer
    public init() {
        
        func makePlanetRepository() -> PlanetRepositoryProtocol {
            let client = makeAPIClient()
            return PlanetRepository(client: client)
        }
        
        func makeAPIClient() -> APIClient {
            return APIClient.shared
        }
        
        func makeRootViewModel() -> RootViewModel {
            return RootViewModel()
        }
        
        sharedPlanetRepository = makePlanetRepository()
        sharedRootViewModel = makeRootViewModel()
    }
    
    // MARK: Factory Methods
    public func makeLaunchViewController() -> LaunchViewController {
        return LaunchViewController(viewModelFactory: self)
    }
    
    public func makeLaunchViewModel() -> LaunchViewModel {
        return LaunchViewModel(planetRepository: sharedPlanetRepository,
                               fetchedPlanetResponder: sharedRootViewModel)
    }
    
    public func makeRootViewController() -> RootViewController {
        let launchViewController = makeLaunchViewController()
        
        let planetNavigationViewControllerFactory = { (planet: Planet) in
            return self.makePlanetNavigationViewController(planet: planet)
        }
        
        return RootViewController(viewModel: sharedRootViewModel,
                                  launchController: launchViewController,
                                  planetNavigationControllerFactory:
            planetNavigationViewControllerFactory)
    }
}

extension AppDependencyContainer: LaunchViewModelFactory {
    
    public func makePlanetNavigationViewController(planet: Planet) -> PlanetNavigationViewController {
        let dependencyContainer = makePlanetDependencyContainer(planet: planet)
        return dependencyContainer.makePlanetNavigationViewController()
    }
    
    public func makePlanetDependencyContainer(planet: Planet) -> PlanetDependencyContainer {
        return PlanetDependencyContainer(planet: planet, appDependencyContainer: self)
    }
}
