//
//  MovieDetailViewModel.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import SwiftData

/// ViewModel responsible for managing the movie details, including runtime loading,
/// download actions, and playback initialization.
@MainActor
final class MovieDetailViewModel: ObservableObject {

	// MARK: - Published Properties

	/// The movie being displayed in the detail view.
	@Published var movie: Movie

	/// Indicates whether data is currently being fetched from the API.
	@Published var isLoading: Bool = false

	/// An error message to display in case of failure.
	@Published var errorMessage: String?

	// MARK: - Computed Properties

	/// Indicates whether the download button should be disabled.
	var isDownloadDisabled: Bool {
		return movie.downloadStatus != .none
	}

	/// Returns the local video file URL if it exists.
	var localVideoURL: URL? {
		return movie.localVideoNSURL
	}

	// MARK: - Dependencies

	/// Repository used to interact with movie persistence and APIs.
	private let movieRepository: MovieRepository

	// MARK: - Initialization

	/// Initializes the view model with a given movie.
	///
	/// - Parameter movie: The movie object to display and manage.
	init(movie: Movie) {
		self.movie = movie
		self.movieRepository = MovieRepository(
			modelContext: PersistenceController.shared.container.mainContext
		)
	}

	// MARK: - Data Fetching

	/// Fetches the movie runtime from the API if it hasn't been loaded yet.
	/// Updates the local movie object and saves the context.
	func fetchRuntimeAndUpdateMovie() async {
		guard movie.duration == 0 else { return }

		isLoading = true
		defer { isLoading = false }

		do {
			let runtime = try await movieRepository.fetchMovieRuntimeFromAPI(movie: movie)
			movie.duration = runtime
			try movieRepository.saveContext()
			print("✅ Updated movie duration: \(runtime) minutes")
		} catch {
			print("❌ Failed to fetch runtime: \(error)")
			errorMessage = "Failed to load movie duration."
		}
	}

	// MARK: - Download Logic

	/// Starts downloading the movie using the shared `DownloadManager`.
	func downloadMovie() {
		guard movie.downloadStatus == .none else { return }
		DownloadManager.shared.queueDownload(for: movie)
	}

	// MARK: - Playback Logic

	/// Prepares the video player using either local or online video URL.
	func playMovie() {
		if movie.downloadStatus == .downloaded,
		   let url = movie.localVideoNSURL {
			VideoManager.shared.setupPlayer(with: url)
			print("Local Movie == \(url)")
		} else {
			VideoManager.shared.setupPlayer(with: movie.onlineVideoNSURL)
			print("Online Movie == \(movie.onlineVideoNSURL)")
		}
	}
}
