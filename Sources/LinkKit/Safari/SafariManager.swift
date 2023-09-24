//
//  SafariManager.swift
//  LinkKit
//
//  Created by David Walter on 04.07.23.
//

#if os(iOS)
import SwiftUI
import SafariServices
import UIKit
import Combine

/// Manages the presented `SFSafariViewController`s and their respective `UIWindow`s
class SafariManager: NSObject, ObservableObject, SFSafariViewControllerDelegate {
    static var shared = SafariManager()
    
    override private init() {
        super.init()
    }
    
    var safariDidFinish = PassthroughSubject<SFSafariViewController, Never>()
    private var windows: [SFSafariViewController: UIWindow] = [:]
    
    @MainActor
    @discardableResult
    func present(_ safari: SFSafariViewController, on windowScene: UIWindowScene, userInterfaceStyle: UIUserInterfaceStyle = .unspecified) -> SFSafariViewController {
        safari.delegate = self
        windowScene.windows.forEach { $0.endEditing(true) }
        let (window, viewController) = setup(windowScene: windowScene, userInterfaceStyle: userInterfaceStyle)
        windows[safari] = window
        viewController.present(safari, animated: true)
        return safari
    }
    
    private func setup(windowScene: UIWindowScene, userInterfaceStyle: UIUserInterfaceStyle) -> (UIWindow, UIViewController) {
        let window = UIWindow(windowScene: windowScene)
        
        let viewController = UIViewController()
        window.overrideUserInterfaceStyle = userInterfaceStyle
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        return (window, viewController)
    }
    
    // MARK: - SFSafariViewControllerDelegate
    
    internal func safariViewControllerDidFinish(_ safari: SFSafariViewController) {
        let window = safari.view.window
        window?.resignKey()
        windows[safari] = nil
        safariDidFinish.send(safari)
    }
}
#endif
