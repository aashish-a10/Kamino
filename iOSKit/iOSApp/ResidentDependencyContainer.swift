//
//  ResidentDependencyContainer.swift
//

import Foundation
import ServiceKit
import CommonKit

public class ResidentDependencyContainer {
    
    // MARK: - Private Properties
    private let resident: Resident
    private let planetRepository: PlanetRepositoryProtocol
    
    // MARK: Initializer
    public init(resident: Resident, appDependencyContainer: PlanetDependencyContainer) {
        self.resident = resident
        self.planetRepository = appDependencyContainer.planetRepository
    }
    
    // MARK: Factory Methods
    public func makeResidentDetailViewController() -> ResidentDetailViewController {
        ResidentDetailViewController(viewModelFactory: self)
    }
}

extension ResidentDependencyContainer: ResidentDetailsViewModelFactory {
    
    public func makeResidentDetailsViewModel() -> ResidentDetailViewModel {
        return ResidentDetailViewModel(resident: resident, planetRepository: planetRepository)
    }
}
