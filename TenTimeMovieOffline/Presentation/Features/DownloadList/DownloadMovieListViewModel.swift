//
//  DownloadMovieViewModel.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import SwiftUI
import SwiftData

/// View model responsible for managing the state and logic of the downloaded movies list.
@MainActor
class DownloadMovieListViewModel: ObservableObject {

	// MARK: - Published Properties

	/// The list of downloaded or downloading movies.
	@Published var movies: [Movie] = []

	/// Indicates whether the view is currently loading data.
	@Published var isLoading: Bool = false

	/// An error message to display if a fetch operation fails.
	@Published var errorMessage: String? = nil

	// MARK: - Dependencies

	/// The movie repository handling data operations.
	private let movieRepository: MovieRepository

	// MARK: - Initialization

	/// Initializes the view model and fetches the list of downloaded movies.
	init() {
		self.movieRepository = MovieRepository(
			modelContext: PersistenceController.shared.container.mainContext
		)
		fetchDownloadedMovies()
	}

	// MARK: - Data Fetching

	/// Fetches the list of downloaded or downloading movies from the repository.
	func fetchDownloadedMovies() {
		isLoading = true
		errorMessage = nil

		do {
			let fetchedMovies = try movieRepository.fetchDownloadedMovies()
			self.movies = fetchedMovies
		} catch {
			self.errorMessage = error.localizedDescription
		}

		isLoading = false
	}

	// MARK: - Deletion

	/// Deletes a downloaded movie and refreshes the list.
	///
	/// - Parameter movie: The movie to be removed.
	func deleteDownloadedMovie(
		at movie: Movie // The movie to delete
	) {
		movieRepository.deleteDownloadedMovies(movie: movie)
		fetchDownloadedMovies()
	}
}
