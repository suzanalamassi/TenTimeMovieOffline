//
//  Movie.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import SwiftData

/// Represents a movie entity stored in the local database and used throughout the application.
@Model
final class Movie: Identifiable {

	// MARK: - Stored Properties

	/// Unique identifier for the movie.
	@Attribute(.unique) var id: Int

	/// The title of the movie.
	var title: String

	/// A brief overview or synopsis of the movie.
	var overview: String

	/// The path to the movie's poster image.
	var posterPath: String?

	/// The language code of the movie (e.g., "en").
	var language: String?

	/// The release date of the movie in `YYYY-MM-DD` format.
	var releaseDate: String

	/// The path to the movie's backdrop image.
	var backdropPath: String?

	/// The list of genre IDs associated with the movie.
	var genreIDs: [Int] = []

	/// The popularity score provided by the API.
	var popularity: Double = 0.0

	/// The average vote score for the movie.
	var voteAverage: Double = 0.0

	/// The total number of user votes.
	var voteCount: Int = 0

	/// List of genres this movie belongs to.
	@Relationship var genres: [Genre] = []

	/// A direct URL string pointing to the online video file.
	var onlineVideoURL: String

	/// Local file path where the video is downloaded (if available).
	var localVideoPath: String? = nil

	/// The duration of the movie in minutes.
	var duration: Int = 0

	/// The raw string value representing the download status.
	var downloadStatusRawValue: String

	/// Download progress percentage (0 to 100).
	var downloadPercentage: Double = 0

	// MARK: - Computed Properties

	/// Computed enum representing the current download status.
	var downloadStatus: DownloadStatus {
		get {
			DownloadStatus(rawValue: downloadStatusRawValue) ?? .none
		}
		set {
			downloadStatusRawValue = newValue.rawValue
		}
	}

	/// Computed URL for the movie's poster thumbnail.
	var thumbnailURL: URL? {
		guard let path = posterPath else { return nil }
		return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
	}

	/// Computed URL for the movie's backdrop image.
	var backdropURL: URL? {
		guard let path = backdropPath else { return nil }
		return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
	}

	/// Computed URL pointing to the online video file.
	var onlineVideoNSURL: URL {
		URL(string: onlineVideoURL)!
	}

	/// Computed URL pointing to the locally saved video file (if available).
	var localVideoNSURL: URL? {
		guard let localVideoPath else { return nil }
		return URL(fileURLWithPath: localVideoPath)
	}

	// MARK: - Initializer

	/// Initializes a new instance of the `Movie` model.
	///
	/// - Parameters:
	///   - id: Unique movie ID.
	///   - title: Movie title.
	///   - overview: Brief description of the movie.
	///   - posterPath: Path to the poster image.
	///   - language: Language code.
	///   - releaseDate: Release date.
	///   - backdropPath: Path to the backdrop image.
	///   - genreIDs: List of genre IDs.
	///   - popularity: Popularity score.
	///   - voteAverage: Average user rating.
	///   - voteCount: Number of votes.
	///   - onlineVideoURL: URL string to the video file.
	///   - localVideoPath: Local storage path for the video file.
	///   - duration: Duration in minutes.
	///   - downloadStatus: Initial download status.
	///   - downloadPercentage: Initial download progress.
	init(
		id: Int,
		title: String,
		overview: String,
		posterPath: String? = nil,
		language: String? = nil,
		releaseDate: String,
		backdropPath: String? = nil,
		genreIDs: [Int] = [],
		popularity: Double = 0.0,
		voteAverage: Double = 0.0,
		voteCount: Int = 0,
		onlineVideoURL: String,
		localVideoPath: String? = nil,
		duration: Int = 0,
		downloadStatus: DownloadStatus = .none,
		downloadPercentage: Double = 0
	) {
		self.id = id
		self.title = title
		self.overview = overview
		self.posterPath = posterPath
		self.language = language
		self.releaseDate = releaseDate
		self.backdropPath = backdropPath
		self.genreIDs = genreIDs
		self.popularity = popularity
		self.voteAverage = voteAverage
		self.voteCount = voteCount
		self.onlineVideoURL = onlineVideoURL
		self.localVideoPath = localVideoPath
		self.duration = duration
		self.downloadStatusRawValue = downloadStatus.rawValue
		self.downloadPercentage = downloadPercentage
	}
}
