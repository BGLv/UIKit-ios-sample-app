//
//  LogInRequest.swift
//  MyMarket
//
//  Created by Bohdan Huk on 28.08.2025.
//
import Foundation
import RxSwift

enum HttpError: Error {
    case badURL
    case noData
}

struct AuthTokenDTO: Decodable {
    let token: String
    let refreshToken: String
    let expiresAt: String
}

class APIAuthService: AuthService {
    func logIn(phone: String, password: String) -> Single<AuthToken> {
        
        return Single<AuthToken>.create { observer in
            guard let url = URL(string: APIConstants.baseURL + Endpoint.login) else {
                observer(.failure(HttpError.badURL))
                return Disposables.create()
            }
            
            let jsonData = try? JSONEncoder().encode([
                "phone": phone,
                "password": password
            ])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                guard let data = data else {
                    observer(.failure(HttpError.noData))
                    return
                }
                
                do {
                    let apiResponse = try JSONDecoder().decode(AuthTokenDTO.self, from: data)
                    observer(.success(AuthToken(
                        token: apiResponse.token,
                        refreshToken: apiResponse.refreshToken,
                        expiresAt: DateFormatter().date(from: apiResponse.expiresAt) ?? Date()
                    )))
                } catch {
                    observer(.failure(error))
                }
            })
            
            dataTask.resume()
            
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
}
