//
//  VideoPlayerControllerView.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI
import AVKit

/// A SwiftUI wrapper for `AVPlayerViewController` to enable advanced video playback features,
/// including Picture-in-Picture support.
struct VideoPlayerControllerView: UIViewControllerRepresentable {

	/// The AVPlayer instance to be used for playback.
	let player: AVPlayer

	// MARK: - UIViewControllerRepresentable

	/// Creates and configures an `AVPlayerViewController` instance.
	///
	/// - Parameter context: The context provided by SwiftUI.
	/// - Returns: A fully configured `AVPlayerViewController`.
	func makeUIViewController(
		context: Context // SwiftUI context for coordinating with UIKit
	) -> AVPlayerViewController {
		let controller = AVPlayerViewController()
		controller.player = player
		controller.allowsPictureInPicturePlayback = true
		controller.canStartPictureInPictureAutomaticallyFromInline = true
		controller.updatesNowPlayingInfoCenter = false
		return controller
	}

	/// Updates the existing `AVPlayerViewController` with new data.
	///
	/// - Parameters:
	///   - uiViewController: The controller to update.
	///   - context: The SwiftUI context.
	func updateUIViewController(
		_ uiViewController: AVPlayerViewController, // The current player controller
		context: Context // SwiftUI context for updates
	) {
		uiViewController.player = player
	}
}
