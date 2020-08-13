//
//  RootViewModel.swift
//

import RxSwift

public class RootViewModel: FetchedPlanetResponder {
    
    // MARK: - Private Properties
    private var viewSubject = BehaviorSubject<RootScene>(value: .launching)
    
    // MARK: - Properties
    public var view: Observable<RootScene> { return viewSubject.asObservable() }
    
    // MARK: Initializer
    public init() { }
    
    // MARK: Methods
    public func fetched(planet: Planet) {
        viewSubject.onNext(.show(planet: planet))
    }
}
