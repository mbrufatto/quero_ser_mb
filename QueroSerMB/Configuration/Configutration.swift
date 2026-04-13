//
//  Configutration.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 13/04/26.
//
import Foundation

enum Configuration {
    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "X-CMC_PRO_API_KEY") as? String else {
            fatalError("ERRO: API Key não encontrada no Info.plist. Verifique as configurações do Target.")
        }
        return key
    }
    
    static var baseUrl: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "baseURL") as? String else {
            fatalError("ERRO: Base Url não encontrada no Info.plist. Verifique as configurações do Target.")
        }
        return key
    }
}
