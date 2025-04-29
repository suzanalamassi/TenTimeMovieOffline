//
//  VideoPlayerFullScreen.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI

/// A fullscreen video playback view that displays the current video using `VideoManager`.
/// Automatically pauses the video when dismissed.
struct VideoPlayerView: View {

	// MARK: - Body

	var body: some View {
		ZStack {
			if let player = VideoManager.shared.player {
				// Show the video using a controller-backed player view
				VideoPlayerControllerView(player: player)
					.ignoresSafeArea()
					.onDisappear {
						VideoManager.shared.pause()
					}
			} else {
				// Fallback UI if no video is available
				Color.black
					.ignoresSafeArea()

				Text("No Video")
					.foregroundColor(.white)
			}
		}
	}
}
