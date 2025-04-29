//
//  CachedAsyncImage.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI

/// A reusable image view that asynchronously loads and caches images from a URL.
/// Falls back to a loading indicator and displays a placeholder while loading.
///
/// Uses `ImageLoader` to handle memory and disk caching.
struct CachedAsyncImage: View {

	// MARK: - Parameters

	/// The remote URL of the image to load.
	let url: URL?

	// MARK: - State

	/// State object managing image loading and caching.
	@StateObject private var loader = ImageLoader()

	// MARK: - Body

	var body: some View {
		ZStack {
			// Placeholder background while loading
			Color.gray.opacity(0.2)

			// Display image if loaded successfully
			if let image = loader.image {
				image
					.resizable()
					.scaledToFill()
			} else {
				// Show progress view during loading
				ProgressView()
					.task {
						await loader.load(from: url)
					}
			}
		}
		.clipShape(RoundedRectangle(cornerRadius: 10))
	}
}
