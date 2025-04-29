//
//  responsible.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import SwiftUI

/// A class responsible for asynchronously loading and caching images from the network.
@MainActor
final class ImageLoader: ObservableObject {

	// MARK: - Published Properties

	/// The loaded SwiftUI `Image` instance.
	@Published var image: Image? = nil // Loaded image

	// MARK: - State

	/// Indicates whether the loader is currently performing a loading operation.
	private(set) var isLoading: Bool = false // Prevents duplicate requests

	// MARK: - Public Methods

	/// Asynchronously loads an image from the given URL.
	///
	/// The method checks the shared URL cache first. If the image is not cached,
	/// it fetches the image over the network and stores the response.
	///
	/// - Parameter url: The URL to load the image from.
	func load(
		from url: URL? // Image source URL
	) async {
		guard let url = url, !isLoading else { return }
		isLoading = true

		let request = URLRequest(url: url)

		// Check cache first
		if let cachedResponse = URLCache.shared.cachedResponse(for: request),
		   let uiImage = UIImage(data: cachedResponse.data) {
			self.image = Image(uiImage: uiImage)
			self.isLoading = false
			return
		}

		// Fetch from network
		do {
			let (data, response) = try await URLSession.shared.data(for: request)
			let cachedData = CachedURLResponse(response: response, data: data)
			URLCache.shared.storeCachedResponse(cachedData, for: request)

			if let uiImage = UIImage(data: data) {
				self.image = Image(uiImage: uiImage)
			}
		} catch {
			// Error handling can be added if needed
		}

		self.isLoading = false
	}
}
