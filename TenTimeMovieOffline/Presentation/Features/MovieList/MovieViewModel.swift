//
//  MovieViewModel.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import Combine
import SwiftData

/// ViewModel responsible for managing movie data, including fetching from API,
/// filtering by genre, and syncing with the local database.
@MainActor
class MovieViewModel: ObservableObject {

	// MARK: - Dependencies

	/// Repository used for all movie-related data operations.
	private let movieRepository: MovieRepository

	// MARK: - Published Properties

	/// List of movies to display in the UI.
	@Published var movies: [Movie] = []

	/// Flag indicating whether movies were fetched from the API.
	@Published var isFetchDataFromAPI: Bool = false

	/// Indicates whether data is currently being loaded.
	@Published var isLoading: Bool = false

	/// Holds an error message to display in the UI when fetch fails.
	@Published var errorMessage: String?

	/// The currently selected genre used for filtering.
	@Published var selectedGenre: Genre? {
		didSet {
			fetchMoviesFromLocal()
		}
	}

	// MARK: - Combine

	/// Holds references to Combine subscriptions for lifecycle management.
	private var cancellables: Set<AnyCancellable> = []

	// MARK: - Initialization

	/// Initializes the view model and starts observing connectivity.
	init() {
		self.movieRepository = MovieRepository(
			modelContext: PersistenceController.shared.container.mainContext
		)
		monitorInternetConnection()
		fetchMoviesFromLocal()
	}

	// MARK: - Connectivity Monitoring

	/// Observes internet connectivity status and triggers an API fetch if connected.
	private func monitorInternetConnection() {
		NetworkMonitor.shared.$isConnected
			.removeDuplicates()
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isConnected in
				print("MovieViewModel - monitorInternetConnection == ", isConnected)
				guard let self = self else { return }

				if isConnected, !self.movies.isEmpty {
					self.fetchMoviesFromAPI()
				}
			}
			.store(in: &cancellables)
	}

	// MARK: - Local Fetching

	/// Fetches movies from the local database based on the selected genre.
	func fetchMoviesFromLocal() {
		if let selectedGenre = selectedGenre {
			do {
				movies = try movieRepository.fetchLocalMovies(for: selectedGenre)

				if movies.isEmpty {
					fetchMoviesFromAPI()
				}
			} catch {
				errorMessage = "Failed to fetch movies: \(error.localizedDescription)"
			}
		}
	}

	// MARK: - API Fetching

	/// Fetches movies from the remote API and syncs them with the local database.
	func fetchMoviesFromAPI() {
		guard !isLoading else { return }

		isLoading = true
		defer { isLoading = false }

		errorMessage = nil

		Task {
			do {
				let movieDTOs = try await movieRepository.fetchMoviesFromAPI()

				for dto in movieDTOs {
					let genres = try movieRepository.fetchGenresByIDs(dto.genre_ids)
					try movieRepository.insertOrUpdateMovie(from: dto, genres: genres)
				}

				isFetchDataFromAPI = true
				fetchMoviesFromLocal()
				try movieRepository.saveContext()

			} catch {
				errorMessage = "Failed to load movies: \(error.localizedDescription)"
			}
		}
	}
}
