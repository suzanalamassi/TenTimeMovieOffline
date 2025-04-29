//
//  MessagePlaceholderView.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI

/// A reusable UI component used to indicate empty or error states.
/// Commonly used when no content is available or an error message needs to be shown.
struct MessagePlaceholderView: View {

	// MARK: - Properties

	/// The SF Symbol name to be displayed above the message.
	let systemImageName: String

	/// The message text describing the current state.
	let message: String

	// MARK: - Body

	var body: some View {
		VStack(spacing: 20) {
			Spacer()

			Image(systemName: systemImageName)
				.resizable()
				.scaledToFit()
				.frame(width: 50, height: 50)
				.foregroundColor(.gray.opacity(0.7))

			Text(message)
				.font(.body)
				.foregroundColor(.gray)
				.multilineTextAlignment(.center)
				.padding(.horizontal, 40)

			Spacer()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.clear)
	}
}
