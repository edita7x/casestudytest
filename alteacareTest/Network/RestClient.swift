//
//  RestClient.swift
//  alteacareTest
//
//  Created by Edit sanrio Putra on 26/10/22.
//

import Foundation
import Alamofire

struct BaseAPI {
    static let url = "https://run.mocky.io/v3/c9a2b598-9c93-4999-bd04-0194839ef2dc"
}

class RestClient {
    
    
    
    private func getAuthHeader() -> HTTPHeaders {
        
        var resultHeader : HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        return resultHeader
    }
    
    private func objectToDict<T: Encodable>(data: T) -> [String:Any]? {
        do {
            let json = try JSONEncoder().encode(data)
            let dictResult = try JSONSerialization.jsonObject(with: json, options: []) as? [String:Any]
            return dictResult
        } catch {
            return nil
        }
    }

    private func buildErrorDto(_ data: Data?) -> ApiErrorDto?  {
        if let dataError = data {
            do {
                let errorDto = try JSONDecoder().decode(ApiErrorDto.self, from: dataError)
                return errorDto
            } catch {
                do {
                    if let dictError = try JSONSerialization.jsonObject(with: dataError) as? [String:Any] {
                        let errorDto = ApiErrorDto(code: (dictError["code"] as? Int) ?? -1,
                                                   message: (dictError["message"] as? String) ?? ""
                        )
                        return errorDto
                    }
                } catch {}
            }
        }
        return nil
    }
    
    func get<T : Decodable>(url: String,
                             responseType: T.Type,
                             complete: @escaping((T?, ApiErrorDto?) -> Void) ) -> DataRequest  {
        let request = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getAuthHeader())
            .validate(statusCode: 200...300)
            .responseDecodable(of: responseType) { dataResponse in
                Log.debug(dataResponse)
                switch dataResponse.result {
                case .failure(let error):
                    
                    if let apiErrorDto = self.buildErrorDto(dataResponse.data) {
                        complete(nil, apiErrorDto)
                        break
                    }
                    complete(nil, ApiErrorDto(code: error.responseCode ?? -1, message: error.localizedDescription))
                    break
                case .success(let data):
                    complete(data, nil)
                    break
            }
        }
        return request
    }
    
}

