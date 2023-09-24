//
//  OpenURLAction+Safari.swift
//  LinkKit
//
//  Created by David Walter on 30.05.23.
//

import SwiftUI
import SafariServices

#if os(iOS)
public extension OpenURLAction.Result {
    @MainActor
    static func safari(_ url: URL) -> Self {
        guard url.supportsSafari else {
            return .systemAction
        }
        
        let scenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
        
        let scene = scenes
            .first { $0.activationState == .foregroundActive } ?? scenes.first
        
        guard let scene = scene else {
            return .systemAction
        }
        
        let window = scene.windows.first { $0.isKeyWindow } ?? scene.windows.first
        
        guard let rootViewController = window?.rootViewController else {
            return .systemAction
        }
        
        let safari = SFSafariViewController(url: url)
        if window?.traitCollection.horizontalSizeClass == .regular {
            safari.modalPresentationStyle = .pageSheet
        }
        
        guard rootViewController.presentedViewController == nil else {
            return .safariWindow(url, in: scene)
        }
        
        rootViewController.present(safari, animated: true)
        return .handled
    }
    
    @MainActor
    static func safari(_ url: URL, configure: (inout SafariConfiguration) -> Void) -> Self {
        guard url.supportsSafari else {
            return .systemAction
        }
        
        let scenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
        
        let scene = scenes
            .first { $0.activationState == .foregroundActive } ?? scenes.first
        
        guard let scene = scene else {
            return .systemAction
        }
        
        let window = scene.windows.first { $0.isKeyWindow } ?? scene.windows.first
        
        guard let rootViewController = window?.rootViewController else {
            return .systemAction
        }
        
        var config = SafariConfiguration()
        configure(&config)
        
        let safari = SFSafariViewController(url: url, configuration: config.configuration)
        safari.preferredBarTintColor = config.preferredBarTintColor
        safari.preferredControlTintColor = config.preferredControlTintColor
        safari.dismissButtonStyle = config.dismissButtonStyle
        if config.modalPresentationStyle == .automatic, window?.traitCollection.horizontalSizeClass == .regular {
            safari.modalPresentationStyle = .pageSheet
        } else {
            safari.modalPresentationStyle = config.modalPresentationStyle
        }
        safari.overrideUserInterfaceStyle = config.overrideUserInterfaceStyle
        
        guard rootViewController.presentedViewController == nil else {
            return .safariWindow(url, in: scene)
        }
        
        rootViewController.present(safari, animated: true)
        return .handled
    }
    
    @MainActor
    static func safariWindow(_ url: URL, in windowScene: UIWindowScene?) -> Self {
        guard url.supportsSafari else {
            return .systemAction
        }
        
        guard let windowScene = windowScene else {
            return .safari(url)
        }
        
        let safari = SFSafariViewController(url: url)
        
        SafariManager.shared.present(safari, on: windowScene)
        
        return .handled
    }
    
    @MainActor
    static func safariWindow(_ url: URL, in windowScene: UIWindowScene?, configure: (inout SafariConfiguration) -> Void) -> Self {
        guard url.supportsSafari else {
            return .systemAction
        }
        
        guard let windowScene = windowScene else {
            return .safari(url)
        }
        
        var config = SafariConfiguration()
        configure(&config)
        
        let safari = SFSafariViewController(url: url, configuration: config.configuration)
        safari.preferredBarTintColor = config.preferredBarTintColor
        safari.preferredControlTintColor = config.preferredControlTintColor
        safari.dismissButtonStyle = config.dismissButtonStyle
        safari.overrideUserInterfaceStyle = config.overrideUserInterfaceStyle
        
        SafariManager.shared.present(safari, on: windowScene, userInterfaceStyle: config.overrideUserInterfaceStyle)
        
        return .handled
    }
}

struct OpenURLActionSafari_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
            .openURL { url, _ in
                .safari(url) { configuration in
                    configuration.modalPresentationStyle = .fullScreen
                    configuration.overrideUserInterfaceStyle = .dark
                }
            }
            .previewDisplayName(".safari")
        
        VStack {
        }
        .sheet(isPresented: .constant(true)) {
            Preview()
                .interactiveDismissDisabled()
        }
        .openURL { url, _ in
            .safari(url) { configuration in
                configuration.modalPresentationStyle = .fullScreen
                configuration.overrideUserInterfaceStyle = .dark
            }
        }
        .previewDisplayName("Safari within Sheet")
        
        Preview()
            .openURL { url, windowScene in
                .safariWindow(url, in: windowScene) { configuration in
                    configuration.modalPresentationStyle = .fullScreen
                    configuration.overrideUserInterfaceStyle = .dark
                }
            }
            .previewDisplayName(".safariWindow")
    }
    
    struct Preview: View {
        @Environment(\.openURL) private var openURL
        
        var body: some View {
            NavigationView {
                List {
                    Button {
                        guard let url = URL(string: "https://davidwalter.at") else {
                            return
                        }
                        openURL(url)
                    } label: {
                        Text("Show Safari")
                    }
                }
                .navigationTitle("Preview")
            }
            .navigationViewStyle(.stack)
        }
    }
}
#endif