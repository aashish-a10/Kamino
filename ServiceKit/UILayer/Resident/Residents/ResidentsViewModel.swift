//
//  ResidentsViewModel.swift
//

import Foundation
import RxSwift
import RxCocoa

public class ResidentsViewModel: ViewModel {
    
    // MARK: Private Properties
    private var residentsId: [Int]
    private(set) public var residents = BehaviorRelay<[Resident]>(value: [])
    
    private let planetRepository: PlanetRepositoryProtocol
    private let navigationResponder: GoToResidentDetailNavigator
    
    // MARK: Properties
    public let title = Constants.Title.residents
    
    // MARK: Initializer
    public init(residents: [String],
                planetRepository: PlanetRepositoryProtocol,
                navigationResponder: GoToResidentDetailNavigator) {
        
        self.residentsId = residents.compactMap { Int($0.split(separator: "/").last ?? "0") }.map { $0 }
        self.planetRepository = planetRepository
        self.navigationResponder = navigationResponder
    }
    
    // MARK: Public Methods
    public func showResidents() {
        indicateLoading(true)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            for id in self.residentsId {
                let semaphore = DispatchSemaphore(value: 0)
                self.planetRepository.fetchResidentDetail(forId: id) { [weak self] result in
                    semaphore.signal()
                    guard let self = self else { return }
                    switch result {
                    case .success(let resident):
                        self.residents.accept(self.residents.value + [resident])
                    case .failure(let error):
                        print(error)
                    }
                    self.indicateLoading(false)
                }
                semaphore.wait()
            }
        }
    }
    
    public func showResidentDetail(for resident: Resident) {
        navigationResponder.navigateToResidentDetail(resident: resident)
    }
    
    private func indicateLoading(_ loading: Bool) {
        isLoading.onNext(!loading)
    }
}
