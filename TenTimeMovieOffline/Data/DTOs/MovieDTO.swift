//
//  MovieDTO.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation

/// A Data Transfer Object (DTO) representing a movie item fetched from the API.
struct MovieDTO: Decodable {

	/// Unique identifier of the movie from the API.
	let id: Int // Movie ID

	/// Title of the movie.
	let title: String // Movie title

	/// Short overview or description of the movie.
	let overview: String // Movie synopsis

	/// Relative path to the movie's poster image.
	let poster_path: String? // Poster image path

	/// Release date in `YYYY-MM-DD` format.
	let release_date: String // Release date

	/// Relative path to the movie's backdrop image.
	let backdrop_path: String? // Backdrop image path

	/// Language code of the original movie language.
	let original_language: String? // ISO 639-1 language code

	/// List of genre IDs associated with the movie.
	let genre_ids: [Int] // Genre identifiers

	/// Popularity score assigned by the API.
	let popularity: Double // Popularity metric

	/// Average user rating.
	let vote_average: Double // Average vote rating

	/// Total number of votes received.
	let vote_count: Int // Number of votes

	/// Duration of the movie in minutes, if available.
	let runtime: Int? // Runtime (optional)
}

/// A container struct representing the movie list response from the API.
struct MovieResponse: Decodable {

	/// List of movie objects returned in the response.
	let results: [MovieDTO] // Movie list
}

/// A separate response model used to decode detailed movie info from the API.
struct MovieDetailResponse: Decodable {

	/// Runtime of the movie in minutes.
	let runtime: Int? // Runtime detail
}
