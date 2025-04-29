//
//  AppDelegate.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 29/04/2025.
//

import UIKit
import AVFoundation

/// The application's delegate responsible for handling lifecycle events and configuring global settings.
class AppDelegate: NSObject, UIApplicationDelegate {

	// MARK: - UIApplicationDelegate

	/// Called when the application has finished launching.
	///
	/// - Parameter application: The singleton app object that manages the app's event loop.
	/// - Parameter launchOptions: A dictionary indicating the reason the app was launched (can be `nil`).
	/// - Returns: A Boolean value indicating whether the app successfully handled the launch request.
	func application(
		_ application: UIApplication, // The application instance
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil // Launch options if any
	) -> Bool {

		// Configure the audio session for background audio and video playback

		let audioSession = AVAudioSession.sharedInstance()

		do {
			// Set the audio session category to playback
			try audioSession.setCategory(.playback)

			// Activate the audio session
			try audioSession.setActive(true, options: [])
		} catch {
			// Handle any errors encountered during audio session configuration
			print("Setting category to AVAudioSessionCategoryPlayback failed.")
		}

		return true
	}
}
