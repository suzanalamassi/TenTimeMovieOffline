//
//  InfoItemView.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 29/04/2025.
//

import SwiftUI

/// A small reusable view that displays a label-value pair vertically,
/// used for showing metadata like duration, language, rating, etc.
struct InfoItemView: View {

	// MARK: - Properties

	/// The title or label of the information (e.g., "Language").
	let title: String

	/// The actual value associated with the title (e.g., "English").
	let value: String

	// MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(title)
				.font(.caption)
				.foregroundColor(.gray)

			Text(value)
				.font(.subheadline)
		}
	}
}
