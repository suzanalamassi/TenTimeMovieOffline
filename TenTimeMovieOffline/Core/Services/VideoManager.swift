//
//  VideoManager.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import AVKit
import Combine

/// A singleton manager responsible for video playback using AVPlayer.
class VideoManager: ObservableObject {

	// MARK: - Shared Instance

	/// Shared singleton instance of `VideoManager`.
	static let shared = VideoManager()

	// MARK: - Published Properties

	/// The current AVPlayer instance used for video playback.
	@Published var player: AVPlayer? = nil

	/// Indicates whether a video is currently playing.
	@Published var isPlaying: Bool = false

	// MARK: - Private Properties

	/// A cancellable observer for tracking playback-related changes (currently unused).
	private var playerObserver: AnyCancellable?

	// MARK: - Initialization

	/// Private initializer to ensure singleton pattern.
	private init() {}

	// MARK: - Player Setup

	/// Sets up the AVPlayer with a provided video URL.
	///
	/// - Parameter url: The URL of the video to be played.
	func setupPlayer(
		with url: URL // The video URL to load into the player
	) {
		DispatchQueue.main.async {
			self.player = AVPlayer(url: url)
			self.isPlaying = false
		}
	}

	// MARK: - Playback Controls

	/// Starts video playback.
	func play() {
		DispatchQueue.main.async {
			self.player?.play()
			self.isPlaying = true
		}
	}

	/// Pauses video playback.
	func pause() {
		DispatchQueue.main.async {
			self.player?.pause()
			self.isPlaying = false
		}
	}

	/// Stops video playback and resets the playhead to the beginning.
	func stop() {
		DispatchQueue.main.async {
			self.player?.pause()
			self.player?.seek(to: .zero)
			self.isPlaying = false
		}
	}
}
