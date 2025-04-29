//
//  TenTimeMovieOfflineApp.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI
import SwiftData
import AVKit

/// The main entry point of the TenTimeMovieOffline application.
@main
struct TenTimeMovieOfflineApp: App {

	// MARK: - Properties

	/// The application delegate adaptor that sets up the custom AppDelegate.
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	/// Shared instance of the network monitor to observe internet connectivity status.
	@ObservedObject private var networkMonitor = NetworkMonitor.shared

	/// Indicates whether the toast is currently shown.
	@State private var showToast = false

	/// The message to be displayed inside the toast.
	@State private var toastMessage = ""

	/// A Boolean indicating whether the toast represents an error.
	@State private var isErrorToast = false

	/// The duration the toast should stay visible.
	@State private var duration = 3.0

	/// Tracks the current internet connection status.
	@State private var InternetConnectionStatus = true

	// MARK: - Scene Construction

	/// The body property that defines the app's main scene and content.
	var body: some Scene {
		WindowGroup {
			MovieListView()
				.toast(
					isPresented: $showToast, // Binding to control toast visibility
					message: toastMessage, // The toast message
					isError: isErrorToast, // Whether the toast indicates an error
					duration: duration // How long the toast stays visible
				)
				.onReceive(
					networkMonitor.$isConnected.removeDuplicates()
				) { isConnected in
					checkinternetconnection(isConnected: isConnected) // Check the internet connection status
				}
		}
		.modelContainer(PersistenceController.shared.container)
	}
}

// MARK: - Private Methods

extension TenTimeMovieOfflineApp {

	/// Checks and updates the internet connection status and shows appropriate toast messages.
	///
	/// - Parameter isConnected: A Boolean indicating whether the device is connected to the internet.
	private func checkinternetconnection(
		isConnected: Bool // Indicates the current internet connection status
	) {
		if InternetConnectionStatus != isConnected {
			InternetConnectionStatus = isConnected

			withAnimation {
				if isConnected {
					toastMessage = "Internet connection restored"
					isErrorToast = false
					duration = 1
					showToast = true
				} else {
					toastMessage = "Internet connection lost"
					isErrorToast = true
					duration = 12
					showToast = true
				}
			}
		}
	}
}
