//
//  GenreRepository.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import SwiftData

/// Repository responsible for handling all local and remote operations related to genre data.
final class GenreRepository {

	// MARK: - Properties

	/// The SwiftData context used for local persistence operations.
	private let modelContext: ModelContext // SwiftData context

	// MARK: - Initialization

	/// Initializes the repository with a given model context.
	///
	/// - Parameter modelContext: The SwiftData context instance.
	init(
		modelContext: ModelContext // Dependency-injected model context
	) {
		self.modelContext = modelContext
	}

	// MARK: - Local Database Operations

	/// Fetches all genres stored in the local database.
	///
	/// - Returns: An array of `Genre` objects sorted by name.
	/// - Throws: Any error encountered during the fetch operation.
	func fetchLocalGenres() throws -> [Genre] {
		let descriptor = FetchDescriptor<Genre>(
			sortBy: [SortDescriptor(\.name)]
		)
		return try modelContext.fetch(descriptor)
	}

	/// Deletes all genre records from the local database.
	///
	/// - Throws: Any error encountered during fetch or deletion.
	func deleteAllGenres() throws {
		let genres = try fetchLocalGenres()
		for genre in genres {
			modelContext.delete(genre)
		}
	}

	/// Inserts a new genre into the local database using a DTO object.
	///
	/// - Parameter dto: The `GenreDTO` object to be inserted.
	func insertGenre(
		from dto: GenreDTO // DTO representing genre data
	) {
		let genre = Genre(id: dto.id, name: dto.name)
		modelContext.insert(genre)
	}

	/// Saves any pending changes to the local data context.
	///
	/// - Throws: Any error encountered while saving.
	func saveContext() throws {
		try modelContext.save()
	}

	// MARK: - Remote API Operations

	/// Fetches a list of genres from the TMDB API.
	///
	/// - Returns: An array of `GenreDTO` objects from the remote API.
	/// - Throws: An error if the URL is invalid or the request fails.
	func fetchGenresFromAPI() async throws -> [GenreDTO] {
		guard let url = URL(string: "\(Constants.baseURL)/genre/movie/list?api_key=\(Constants.apiKey)") else {
			throw URLError(.badURL)
		}

		let response: GenreResponse = try await APIClient.shared.get(url)
		return response.genres
	}
}
