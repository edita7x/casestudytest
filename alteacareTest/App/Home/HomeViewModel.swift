//
//  HomeViewModel.swift
//  alteacareTest
//
//  Created by Edit sanrio Putra on 26/10/22.
//

import Foundation
import RxSwift

class HomeViewModel {
    private let repository = HomeRepository()

    private let _liveData = PublishSubject<HomeResponseDto>()
    var liveData: Observable<HomeResponseDto>{ get {
        return _liveData
    }}
    
    private let _liveError = PublishSubject<String>()
    var liveError: Observable<String> { get{
        return _liveError
    }}
    
    func getCardsData() {
        self.repository.requestCards(onSuccess: {data in
            self._liveData.onNext(data)
        }, onError: { error in
            self._liveError.onNext(error.message)
        })
    }
}
