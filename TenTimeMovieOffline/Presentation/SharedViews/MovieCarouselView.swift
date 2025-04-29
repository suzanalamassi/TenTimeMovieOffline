//
//  MoviePosterCard.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI

/// A horizontally scrollable movie card used in a carousel layout.
/// Displays the movie poster, its title, and the current index out of total.
struct MovieCarouselView: View {

	// MARK: - Properties

	/// URL of the movie poster image.
	let thumbnailURL: URL?

	/// The movie's title displayed at the bottom of the card.
	let title: String

	/// The index of the current movie (e.g., 2 out of 5).
	let index: Int

	/// Total number of movies in the carousel.
	let total: Int

	// MARK: - Body

	var body: some View {
		ZStack(alignment: .bottomLeading) {

			// Movie Poster Image
			CachedAsyncImage(url: thumbnailURL)
				.frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
				.clipped()
				.cornerRadius(12)

			// Gradient Overlay at Bottom
			LinearGradient(
				gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.7)]),
				startPoint: .top,
				endPoint: .bottom
			)
			.frame(height: 70)
			.cornerRadius(12)

			// Index Badge at Top-Right
			VStack {
				HStack {
					Spacer()
					Text("\(index)/\(total)")
						.font(.caption)
						.padding(.horizontal, 8)
						.padding(.vertical, 4)
						.background(Color.black.opacity(0.5))
						.clipShape(Capsule())
						.foregroundColor(.white)
						.padding([.top, .trailing], 10)
				}
				Spacer()
			}

			// Title at Bottom-Left
			Text(title)
				.font(.headline)
				.foregroundColor(.white)
				.lineLimit(2)
				.padding([.leading, .bottom], 12)
		}
		.frame(height: 200)
	}
}
