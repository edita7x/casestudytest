//
//  HomeRepository.swift
//  alteacareTest
//
//  Created by Edit sanrio Putra on 26/10/22.
//

import Foundation

class HomeRepository {
    
    func requestCards(onSuccess: @escaping(HomeResponseDto) ->(), onError: @escaping(ApiErrorDto) -> ()) {
        let url = BaseAPI.url
        let restClient = RestClient()
        
        let _ = restClient.get(url: url, responseType: HomeResponseDto.self, complete: { result, error in
            if let data = result  {
                onSuccess(data)
            } else if (error != nil) {
                onError(error!)
            }
        })
    }
    
}
