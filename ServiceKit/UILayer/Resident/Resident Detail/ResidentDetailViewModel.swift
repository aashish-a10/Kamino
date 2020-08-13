//
//  ResidentDetailViewModel.swift
//

import Foundation
import RxSwift
import RxCocoa

public class ResidentDetailViewModel: ViewModel {
    
    // MARK: Private Properties
    private let planetRepository: PlanetRepositoryProtocol
    
    private(set) var resident: Resident
    private(set) public var residentDetails = BehaviorRelay<[(String, String)]>(value: [])
    public let title: String
    
    public let imageDataInput = BehaviorSubject<Data?>(value: nil)
    
    // MARK: Initializer
    public init(resident: Resident,
                planetRepository: PlanetRepositoryProtocol) {
        self.resident = resident
        self.title = resident.name
        self.planetRepository = planetRepository
        super.init()
        
        setupPlanetDetails()
    }
    
    // MARK: Public Methods
    public func downloadImage() {
        indicateLoading(true)
        planetRepository.downloadImage(urlString: resident.imageUrl) { result in
            switch result {
            case .success(let data):
                self.imageDataInput.onNext(data)
            case .failure(let error):
                print(error)
                self.indicateErrorInLoading(error)
            }
            self.indicateLoading(false)
        }
    }
    
    // MARK: Private Methods
    private func setupPlanetDetails() {
        let details = [(Constants.Resident.name, resident.name),
                       (Constants.Resident.height, resident.height),
                       (Constants.Resident.mass, resident.mass),
                       (Constants.Resident.hairColor, resident.hairColor),
                       (Constants.Resident.skinColor, resident.skinColor),
                       (Constants.Resident.eyeColor, resident.eyeColor),
                       (Constants.Resident.birthYear, resident.birthYear),
                       (Constants.Resident.gender, resident.gender)]
        residentDetails.accept(details)
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
