//
//  responsible.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation

/// A singleton class responsible for performing HTTP network requests.
final class APIClient {

	// MARK: - Properties

	/// The shared instance of the APIClient used for making network requests.
	static let shared = APIClient() // Shared instance

	// MARK: - Initializer

	/// Private initializer to prevent external instantiation.
	private init() {}

	// MARK: - Public Methods

	/// Sends a GET request to the specified URL and decodes the response into a Decodable type.
	///
	/// - Parameter url: The URL to which the GET request will be sent.
	/// - Returns: A decoded object of the specified type `T`.
	/// - Throws: An error if the network request fails or decoding fails.
	func get<T: Decodable>(
		_ url: URL // The URL for the GET request
	) async throws -> T {
		let (data, response) = try await URLSession.shared.data(from: url)

		guard let httpResponse = response as? HTTPURLResponse,
			  (200...299).contains(httpResponse.statusCode) else {
			throw URLError(.badServerResponse)
		}

		return try JSONDecoder().decode(T.self, from: data)
	}
}
