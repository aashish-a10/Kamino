//
//  ViewModel.swift
//

import Foundation
import RxSwift

protocol ViewModelProtocol {
    var errorMessageSubject: PublishSubject<ErrorMessage> { get }
    var errorMessages: Observable<ErrorMessage> { get }
    var errorPresentation: BehaviorSubject<ErrorPresentation?> { get }
    var isLoading: BehaviorSubject<Bool> { get }
}

public class ViewModel: ViewModelProtocol {
    var errorMessageSubject = PublishSubject<ErrorMessage>()
    public var errorMessages: Observable<ErrorMessage> { return errorMessageSubject.asObservable() }
    public internal(set) var errorPresentation: BehaviorSubject<ErrorPresentation?> = BehaviorSubject(value: nil)
    public internal(set) var isLoading = BehaviorSubject<Bool>(value: false)
}
