//
//  SectionView.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI

/// A reusable section view that displays a horizontally scrollable list of movie posters.
/// Commonly used to represent grouped content such as "Trending Now" or "Recently Added".
struct MovieCategoryView: View {

	// MARK: - Properties

	/// Title of the section (e.g., "Trending Now").
	let title: String

	/// Array of movie objects to display.
	let movies: [Movie]

	/// Callback triggered when a movie is tapped.
	let onMovieSelected: (Movie) -> Void

	// MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {

			// Section title
			Text(title)
				.font(.title2)
				.bold()
				.padding(.horizontal)

			// Horizontal scrollable movie list
			ScrollView(.horizontal, showsIndicators: false) {
				LazyHStack(spacing: 16) {
					ForEach(movies) { movie in
						VStack(alignment: .leading, spacing: 8) {
							// Movie thumbnail image
							CachedAsyncImage(url: movie.thumbnailURL)
								.scaledToFill()
								.frame(width: 120, height: 180)
								.cornerRadius(10)
								.clipped()
								.onTapGesture {
									onMovieSelected(movie)
								}

							// Movie title
							Text(movie.title)
								.font(.system(size: 14))
								.foregroundColor(.white)
								.lineLimit(2)
								.multilineTextAlignment(.leading)
								.fixedSize(horizontal: false, vertical: true)
								.frame(width: 120, alignment: .leading)
						}
						.frame(width: 120) // Ensures consistent spacing in layout
					}
				}
				.padding(.horizontal)
				.padding(.bottom)
			}
		}
	}
}
