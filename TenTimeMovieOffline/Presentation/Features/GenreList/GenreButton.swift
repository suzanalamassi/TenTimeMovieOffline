//
//  GenreButton.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI

/// A stylized, tappable button that displays a genre and indicates selection state.
struct GenreButton: View {

	/// The genre object displayed on the button.
	let genre: Genre // Genre model

	/// Indicates whether this genre is currently selected.
	let isSelected: Bool // Selection state

	/// Action to perform when the button is tapped.
	let action: () -> Void // Tap handler

	// MARK: - View

	var body: some View {
		Button(action: action) {
			Text(genre.name)
				.font(.subheadline)
				.padding(.vertical, 8)
				.padding(.horizontal, 16)
				.background(isSelected ? Color.white.opacity(0.2) : Color.clear)
				.cornerRadius(20)
				.foregroundColor(isSelected ? .white : .gray)
		}
	}
}
