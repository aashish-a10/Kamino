//
//  PlanetNavigationViewModel.swift
//

import Foundation
import RxSwift

public protocol GoToResidentsNavigator {
    func navigateToResidents()
}

public protocol GoToResidentDetailNavigator {
    func navigateToResidentDetail(resident: Resident)
}

public typealias PlanetNavigationAction = NavigationAction<PlanetScene>

public class PlanetNavigationViewModel: GoToResidentsNavigator, GoToResidentDetailNavigator {
    
    // MARK: - Private Properties
    private let _navigationAction = BehaviorSubject<PlanetNavigationAction>(value: .present(view: .planet))
    
    public var navigationAction: Observable<PlanetNavigationAction> {
        return _navigationAction.asObservable()
    }
    
    public init() {}
    
    // MARK: - Methods
    public func navigateToResidents() {
        _navigationAction.onNext(.present(view: .residents))
    }
    
    public func navigateToResidentDetail(resident: Resident) {
        _navigationAction.onNext(.present(view: .residentDetail(resident: resident)))
    }
}
