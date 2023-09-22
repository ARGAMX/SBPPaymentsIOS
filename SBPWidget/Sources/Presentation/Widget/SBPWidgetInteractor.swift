//
//  SBPWidgetInteractor.swift
//  SBPWidget
//
//  Created by Mykola Hordynchuk on 04.12.2020.
//  Copyright © 2020 Mykola Hordynchuk. All rights reserved.
//

import UIKit

protocol SBPWidgetPresenterToInteractorProtocol: AnyObject {
  func getBankApplications(banksJsonURL: String?)
  func getApplicationSchema(with index: Int)
}

extension SBPWidgetPresenterToInteractorProtocol {
  func getBankApplications() {
    getBankApplications(banksJsonURL: nil)
  }
}

final class SBPWidgetInteractor {
  weak var presenter: SBPWidgetInteractorToPresenterProtocol?
  var sbpBankService: SBPBankServiceProtocol!
  var bankApps: [SBPBank] = []
}


extension SBPWidgetInteractor: SBPWidgetPresenterToInteractorProtocol {
  func getBankApplications(banksJsonURL: String? = nil) {
    do {
      let apps = try sbpBankService.getBankApplications(banksJsonURL: banksJsonURL)
      checkiOSApplications(with: apps)
      bankApps = apps.filter { $0.isInstalled }
      presenter?.onInteractorReceivedBankApplications(bankApps)
    } catch {
      presenter?.onInteractorError(error)
    }
  }
  
  func getApplicationSchema(with index: Int) {
    presenter?.onInteractorSelectedBankApplicationScheme(bankApps[index].schema)
  }
}

private
extension SBPWidgetInteractor {
  func checkiOSApplications(with schemas: [SBPBank]) {
    schemas.forEach {
      if let url = URL(string: $0.schema + "://") {
        if UIApplication.shared.canOpenURL(url) {
          $0.isInstalled = true
        }
      }
    }
  }
}


