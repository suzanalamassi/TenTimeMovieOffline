//
//  GenreListView.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI

/// A horizontally scrollable list of genre buttons.
/// Each button represents a genre and updates the selected genre when tapped.
struct GenreListView: View {

	/// The view model that provides genres and handles selection logic.
	@ObservedObject var viewModel: GenreViewModel // Injected ViewModel

	// MARK: - View

	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 8) {
				ForEach(viewModel.genres, id: \.self) { genre in
					GenreButton(
						genre: genre, // Genre to display
						isSelected: viewModel.selectedGenre?.id == genre.id, // Highlight if selected
						action: {
							viewModel.selectGenre(genre) // Update selected genre
						}
					)
				}
			}
			.padding(.vertical, 20)
			.padding(.horizontal, 10)
		}
	}
}
