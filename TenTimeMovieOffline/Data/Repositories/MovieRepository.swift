//
//  MovieRepository.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import SwiftData

/// Repository responsible for managing all local and remote operations related to movies.
final class MovieRepository {

	// MARK: - Properties

	/// The SwiftData context used for persistence operations.
	private let modelContext: ModelContext

	// MARK: - Initialization

	/// Initializes the repository with a given model context.
	///
	/// - Parameter modelContext: The context used to interact with the database.
	init(modelContext: ModelContext) {
		self.modelContext = modelContext
	}

	// MARK: - Local Fetching

	/// Fetches movies from the local database, optionally filtered by genre.
	///
	/// - Parameter genre: The genre to filter movies by (optional).
	/// - Returns: An array of matching `Movie` instances.
	/// - Throws: Errors during the fetch process.
	func fetchLocalMovies(for genre: Genre?) throws -> [Movie] {
		do {
			let descriptor: FetchDescriptor<Movie>

			if let genre = genre {
				let genreID = genre.id
				descriptor = FetchDescriptor<Movie>(
					predicate: #Predicate<Movie> { movie in
						movie.genres.contains(where: { $0.id == genreID })
					},
					sortBy: [SortDescriptor(\Movie.releaseDate, order: .reverse)]
				)
			} else {
				descriptor = FetchDescriptor<Movie>(
					sortBy: [SortDescriptor(\Movie.releaseDate, order: .reverse)]
				)
			}

			let movies = try modelContext.fetch(descriptor)
			print("✅ Successfully fetched \(movies.count) movies from local database. === \(genre?.name ?? "")")
			return movies
		} catch {
			print("❌ Failed to fetch movies from local database: \(error)")
			throw error
		}
	}

	// MARK: - Insert / Update

	/// Inserts a new movie or updates an existing one using a DTO.
	///
	/// - Parameters:
	///   - dto: The `MovieDTO` object from the API.
	///   - genres: The list of `Genre` entities to associate with the movie.
	/// - Throws: Errors during fetching or insertion.
	func insertOrUpdateMovie(from dto: MovieDTO, genres: [Genre]) throws {
		let movieID = dto.id

		let fetchDescriptor = FetchDescriptor<Movie>(
			predicate: #Predicate<Movie> { movie in
				movie.id == movieID
			}
		)

		if let existingMovie = try modelContext.fetch(fetchDescriptor).first {
			// Update existing movie
			existingMovie.title = dto.title
			existingMovie.overview = dto.overview
			existingMovie.posterPath = dto.poster_path
			existingMovie.releaseDate = dto.release_date
			existingMovie.backdropPath = dto.backdrop_path
			existingMovie.genreIDs = dto.genre_ids
			existingMovie.popularity = dto.popularity
			existingMovie.voteAverage = dto.vote_average
			existingMovie.voteCount = dto.vote_count
			existingMovie.onlineVideoURL = RandomVideoProvider.randomVideoURL().absoluteString
			existingMovie.genres = genres
		} else {
			// Insert new movie
			let movie = Movie(
				id: dto.id,
				title: dto.title,
				overview: dto.overview,
				posterPath: dto.poster_path,
				releaseDate: dto.release_date,
				backdropPath: dto.backdrop_path,
				genreIDs: dto.genre_ids,
				popularity: dto.popularity,
				voteAverage: dto.vote_average,
				voteCount: dto.vote_count,
				onlineVideoURL: RandomVideoProvider.randomVideoURL().absoluteString
			)
			movie.genres = genres
			modelContext.insert(movie)
		}
	}

	// MARK: - Save Context

	/// Saves any pending changes to the local context.
	///
	/// - Throws: Errors encountered during save.
	func saveContext() throws {
		try modelContext.save()
	}

	// MARK: - Remote API

	/// Fetches popular movies from the TMDB API.
	///
	/// - Returns: A list of `MovieDTO` from the API.
	/// - Throws: Errors during the API call or decoding.
	func fetchMoviesFromAPI() async throws -> [MovieDTO] {
		guard let url = URL(string: "\(Constants.baseURL)/movie/popular?api_key=\(Constants.apiKey)") else {
			throw URLError(.badURL)
		}
		let response: MovieResponse = try await APIClient.shared.get(url)
		return response.results
	}

	/// Fetches the runtime of a specific movie from the TMDB API.
	///
	/// - Parameter movie: The movie to fetch runtime for.
	/// - Returns: Runtime in minutes.
	/// - Throws: Errors during the API call or decoding.
	func fetchMovieRuntimeFromAPI(movie: Movie) async throws -> Int {
		let urlString = "\(Constants.baseURL)/movie/\(movie.id)?api_key=\(Constants.apiKey)"
		guard let url = URL(string: urlString) else {
			throw URLError(.badURL)
		}

		let movieDetails: MovieDetailResponse = try await APIClient.shared.get(url)
		return movieDetails.runtime ?? 0
	}

	// MARK: - Genre Linking

	/// Fetches genres from the local database based on a list of IDs.
	///
	/// - Parameter ids: The list of genre IDs.
	/// - Returns: A list of matching `Genre` objects.
	/// - Throws: Errors during the fetch operation.
	func fetchGenresByIDs(_ ids: [Int]) throws -> [Genre] {
		let descriptor = FetchDescriptor<Genre>(
			predicate: #Predicate { genre in
				ids.contains(genre.id)
			}
		)
		return try modelContext.fetch(descriptor)
	}

	// MARK: - Downloads

	/// Fetches all movies that have been downloaded or are in the process of downloading.
	///
	/// - Returns: A sorted list of downloaded or downloading movies.
	/// - Throws: Errors during the fetch operation.
	func fetchDownloadedMovies() throws -> [Movie] {
		let downloadStatus = DownloadStatus.none.rawValue

		let descriptor = FetchDescriptor<Movie>(
			predicate: #Predicate<Movie> { movie in
				movie.downloadStatusRawValue != downloadStatus
			}
		)

		var movies = try modelContext.fetch(descriptor)

		// Sort by download status priority, then by release date
		movies.sort { lhs, rhs in
			let lhsPriority = priority(for: lhs.downloadStatusRawValue)
			let rhsPriority = priority(for: rhs.downloadStatusRawValue)

			if lhsPriority != rhsPriority {
				return lhsPriority < rhsPriority
			} else {
				return lhs.releaseDate > rhs.releaseDate
			}
		}

		return movies
	}

	/// Returns a numeric priority value for a given download status.
	///
	/// - Parameter statusRawValue: The raw string value of the status.
	/// - Returns: An integer representing priority (higher is more important).
	private func priority(for statusRawValue: String) -> Int {
		switch DownloadStatus(rawValue: statusRawValue) {
			case .downloaded:
				return 3
			case .downloading:
				return 2
			case .waiting:
				return 1
			default:
				return 0
		}
	}

	/// Deletes the downloaded movie file and updates the movie's download status.
	///
	/// - Parameter movie: The movie whose downloaded file should be deleted.
	func deleteDownloadedMovies(movie: Movie) {
		// Delete local video file if it exists
		if let localPath = movie.localVideoPath, !localPath.isEmpty {
			let fileURL = URL(fileURLWithPath: localPath)
			if FileManager.default.fileExists(atPath: fileURL.path) {
				do {
					try FileManager.default.removeItem(at: fileURL)
					print("🗑️ Deleted local video file: \(fileURL)")
				} catch {
					print("❌ Failed to delete local video file: \(error)")
				}
			}
		}

		// Clear local path and update status
		movie.localVideoPath = nil
		movie.downloadStatus = .none

		// Save changes
		do {
			try saveContext()
			print("✅ Movie updated and saved successfully")
		} catch {
			print("❌ Failed to save movie changes: \(error)")
		}
	}
}
