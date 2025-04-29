//
//  MovieListView.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI
import SwiftData

/// Displays a categorized list of movies, including genre filters, trending sections,
/// and a carousel. Integrates with download status and movie detail navigation.
struct MovieListView: View {

	// MARK: - Stored Properties

	/// Fetched list of movies with download status other than `.none`.
	@Query(filter: #Predicate<Movie> { $0.downloadStatusRawValue != "none" })
	private var downloadedMovies: [Movie]

	/// View model responsible for managing and displaying movies.
	@StateObject private var movieViewModel: MovieViewModel

	/// View model for managing selected genres and filtering.
	@StateObject private var genreViewModel: GenreViewModel

	/// The currently selected movie for navigation.
	@State private var selectedMovie: Movie? = nil

	// MARK: - Initialization

	/// Initializes the movie and genre view models.
	init() {
		_movieViewModel = StateObject(wrappedValue: MovieViewModel())
		_genreViewModel = StateObject(wrappedValue: GenreViewModel())
	}

	// MARK: - Body

	var body: some View {
		NavigationStack {
			ScrollView(showsIndicators: false) {
				VStack(spacing: 20) {

					// Genre filter bar
					GenreListView(viewModel: genreViewModel)
						.onChange(of: genreViewModel.selectedGenre) {
							movieViewModel.selectedGenre = genreViewModel.selectedGenre
						}

					// Loading and error states
					if movieViewModel.isLoading && movieViewModel.movies.isEmpty {
						ProgressView("Loading movies...")
							.frame(minHeight: UIScreen.main.bounds.height * 0.5)
					} else if let errorMessage = movieViewModel.errorMessage {
						MessagePlaceholderView(systemImageName: "exclamationmark.triangle", message: errorMessage)
							.frame(minHeight: UIScreen.main.bounds.height * 0.5)
					} else if movieViewModel.movies.isEmpty {
						MessagePlaceholderView(systemImageName: "film", message: "No movies available.")
							.frame(minHeight: UIScreen.main.bounds.height * 0.5)
					} else {
						// Main movie sections
						carouselSection

						MovieCategoryView(
							title: "Trending Now",
							movies: movieViewModel.movies,
							onMovieSelected: { movie in
								selectedMovie = movie
							}
						)

						MovieCategoryView(
							title: "Recently Added",
							movies: movieViewModel.movies.reversed(),
							onMovieSelected: { movie in
								selectedMovie = movie
							}
						)
					}
				}
				.navigationTitle("SFMovie")
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						NavigationLink(destination: DownloadMovieList()) {
							ZStack(alignment: .topTrailing) {
								Image(systemName: "arrow.down.circle")
									.font(.headline)
									.foregroundColor(.white)

								if downloadedMovies.count != 0 {
									Text("\(downloadedMovies.count)")
										.font(.caption2)
										.fontWeight(.bold)
										.foregroundColor(.white)
										.padding(5)
										.background(Color.purple)
										.clipShape(Circle())
										.offset(x: 10, y: -10)
								}
							}
						}
					}
				}
			}
			.refreshable {
				movieViewModel.fetchMoviesFromAPI()
			}
			.navigationDestination(item: $selectedMovie) { movie in
				MovieDetailView(movie: movie)
			}
		}
		.navigationBarTitleDisplayMode(.large)
		.preferredColorScheme(.dark)
		.tint(.white)
	}

	// MARK: - Carousel Section

	/// Displays a horizontal scroll view with a subset of top movies in carousel format.
	private var carouselSection: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 20) {
				ForEach(Array(movieViewModel.movies.prefix(5).enumerated()), id: \.1.id) { index, movie in
					MovieCarouselView(
						thumbnailURL: movie.thumbnailURL,
						title: movie.title,
						index: index + 1,
						total: 5
					)
					.onTapGesture {
						selectedMovie = movie
					}
				}
			}
			.padding(.horizontal, 20)
		}
		.padding(.bottom, 30)
	}
}
