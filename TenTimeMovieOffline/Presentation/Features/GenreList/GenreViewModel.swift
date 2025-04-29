//
//  GenreViewModel.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import Combine
import SwiftData

/// View model responsible for managing genre data, including fetching from API and local database.
@MainActor
class GenreViewModel: ObservableObject {

	// MARK: - Dependencies

	/// Repository for handling genre-related data operations.
	private let genreRepository: GenreRepository

	// MARK: - Published Properties

	/// List of genres to display.
	@Published var genres: [Genre] = []

	/// Currently selected genre.
	@Published var selectedGenre: Genre?

	/// Indicates whether data is currently being fetched.
	@Published var isLoading: Bool = false

	/// Stores any error messages to be shown to the user.
	@Published var errorMessage: String?

	// MARK: - Private Properties

	/// A set of Combine cancellables for subscriptions.
	private var cancellables: Set<AnyCancellable> = []

	// MARK: - Initialization

	/// Initializes the view model, loads local genres, and begins monitoring internet connection.
	init() {
		self.genreRepository = GenreRepository(modelContext: PersistenceController.shared.container.mainContext)
		self.monitorInternetConnection()
		self.fetchLocalGenres()
		Task {
			await self.fetchGenresFromAPI()
		}
	}

	// MARK: - Connectivity Monitoring

	/// Observes changes in internet connectivity and triggers API fetch if needed.
	private func monitorInternetConnection() {
		NetworkMonitor.shared.$isConnected
			.removeDuplicates()
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isConnected in
				guard let self = self else { return }

				if isConnected, self.genres.isEmpty {
					Task {
						await self.fetchGenresFromAPI()
					}
				}
			}
			.store(in: &cancellables)
	}

	// MARK: - API Fetching

	/// Fetches genres from the TMDB API and saves them locally.
	func fetchGenresFromAPI() async {
		guard !isLoading else { return }

		isLoading = true

		defer {
			isLoading = false
			fetchLocalGenres()
		}

		do {
			let genreDTOs = try await genreRepository.fetchGenresFromAPI()
			try genreRepository.deleteAllGenres()

			for dto in genreDTOs {
				genreRepository.insertGenre(from: dto)
			}

			try genreRepository.saveContext()

		} catch {
			errorMessage = "Failed to load genres: \(error.localizedDescription)"
		}
	}

	// MARK: - Local Fetching

	/// Fetches genres from the local database and selects the first one if available.
	func fetchLocalGenres() {
		do {
			genres = try genreRepository.fetchLocalGenres()

			if let genre = genres.first {
				selectGenre(genre)
			}

			if genres.isEmpty {
				Task {
					await fetchGenresFromAPI()
				}
			}

		} catch {
			errorMessage = "Failed to load genres: \(error.localizedDescription)"
		}
	}

	// MARK: - Selection

	/// Sets the selected genre.
	///
	/// - Parameter genre: The genre to be marked as selected.
	func selectGenre(_ genre: Genre) {
		selectedGenre = genre
	}
}
