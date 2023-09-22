//
//  SBPBankService.swift
//  SBPWidget
//
//  Created by Mykola Hordynchuk on 05.12.2020.
//  Copyright © 2020 Mykola Hordynchuk. All rights reserved.
//

import Foundation

protocol SBPBankServiceProtocol {
  func getBankApplications(banksJsonURL: String?) throws -> [SBPBank]
}

extension SBPBankServiceProtocol {
  func sgetBankApplications() throws -> [SBPBank] {
    try getBankApplications(banksJsonURL: nil)
  }
}

final class SBPBankService: SBPBankServiceProtocol {
  private let url = "https://qr.nspk.ru/proxyapp/c2bmembers.json"
  
  func getBankApplications(banksJsonURL: String? = nil) throws -> [SBPBank] {
    var url = URL(string: defaultUrl)!
    if let banksJsonURL = banksJsonURL, let customUrl = URL(string: banksJsonURL) {
      url = customUrl
    }
    let data = try Data(contentsOf: url, options: .alwaysMapped)
    let decoder = JSONDecoder()
    let jsonData = try decoder.decode(SBPBankRaw.self, from: data)
    return jsonData.dictionary
  }
}
