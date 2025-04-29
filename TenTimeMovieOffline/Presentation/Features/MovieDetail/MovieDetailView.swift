//
//  MovieDetailView.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI

/// A detailed screen showing full movie information, and providing playback and download options.
struct MovieDetailView: View {

	/// ViewModel managing movie details and download/play actions.
	@StateObject private var viewModel: MovieDetailViewModel

	/// Used to dismiss the current view.
	@Environment(\.dismiss) private var dismiss

	/// Indicates whether the video player should be shown.
	@State private var showPlayer = false

	/// Initializes the detail view with a given movie.
	///
	/// - Parameter movie: The movie to display in detail.
	init(movie: Movie) {
		_viewModel = StateObject(wrappedValue: MovieDetailViewModel(movie: movie))
	}

	// MARK: - Body

	var body: some View {
		NavigationStack {
			ScrollView(showsIndicators: false) {
				movieHeaderView
				movieTitleDescTimeView
				moviePlayDownloadButtonView
			}
			.ignoresSafeArea(edges: .top)
			.fullScreenCover(isPresented: $showPlayer) {
				VideoPlayerView()
			}
			.toolbar(.hidden, for: .navigationBar)
		}
		.task {
			await viewModel.fetchRuntimeAndUpdateMovie()
		}
	}
}

// MARK: - Header Section

extension MovieDetailView {
	/// Displays the movie thumbnail with a gradient overlay, back button, and play button.
	private var movieHeaderView: some View {
		ZStack(alignment: .topLeading) {
			CachedAsyncImage(url: viewModel.movie.thumbnailURL)
				.frame(height: UIScreen.main.bounds.height * 9 / 16)
				.clipped()

			LinearGradient(
				gradient: Gradient(colors: [Color.black.opacity(1), Color.clear]),
				startPoint: .bottom,
				endPoint: .top
			)
			.frame(height: UIScreen.main.bounds.height * 9 / 16)

			HStack {
				Button(action: { dismiss() }) {
					Image(systemName: "chevron.left")
						.font(.title2)
						.foregroundColor(.white)
						.padding()
						.background(Color.black.opacity(0.6))
						.clipShape(Circle())
				}
				Spacer()
			}
			.padding()
			.padding(.top, 40)

			Button(action: {
				viewModel.playMovie()
				showPlayer = true
			}) {
				Image(systemName: "play.circle.fill")
					.font(.system(size: 60))
					.foregroundColor(.white)
					.shadow(radius: 10)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}
}

// MARK: - Information Section

extension MovieDetailView {
	/// Displays the movie's title, runtime, language, vote info, and description.
	private var movieTitleDescTimeView: some View {
		VStack(alignment: .leading, spacing: 16) {
			Text(viewModel.movie.title)
				.font(.title)
				.bold()
				.foregroundColor(.white)

			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 35) {
					if viewModel.movie.duration > 0 {
						InfoItemView(title: "Duration", value: "\(viewModel.movie.duration) mins")
					}
					if let language = viewModel.movie.language, !language.isEmpty {
						InfoItemView(title: "Language", value: language)
					}
					if viewModel.movie.voteCount > 0 {
						InfoItemView(title: "Votes", value: "\(viewModel.movie.voteCount)")
					}
					if viewModel.movie.voteAverage > 0 {
						InfoItemView(title: "Rating", value: String(format: "%.1f", viewModel.movie.voteAverage))
					}
					if viewModel.movie.popularity > 0 {
						InfoItemView(title: "Popularity", value: String(format: "%.0f", viewModel.movie.popularity))
					}
					if !viewModel.movie.releaseDate.isEmpty {
						InfoItemView(title: "Release", value: viewModel.movie.releaseDate)
					}
				}
			}
			.padding(.vertical, 8)

			VStack(alignment: .leading, spacing: 8) {
				Text("Description")
					.font(.headline)
					.foregroundColor(.white)

				Text(viewModel.movie.overview)
					.font(.body)
					.foregroundColor(.gray)
			}
		}
		.padding(.horizontal)
		.padding(.top)
	}
}

// MARK: - Actions Section

extension MovieDetailView {
	/// Displays the "Play" and "Download" action buttons.
	private var moviePlayDownloadButtonView: some View {
		HStack(spacing: 20) {
			Button(action: {
				viewModel.playMovie()
				showPlayer = true
			}) {
				Label("Play", systemImage: "play.fill")
					.padding()
					.frame(maxWidth: .infinity)
					.background(Color.purple)
					.cornerRadius(12)
					.foregroundColor(.white)
			}

			Button(action: {
				viewModel.downloadMovie()
			}) {
				Label(viewModel.movie.downloadStatus.textDescription,
					  systemImage: viewModel.movie.downloadStatus.iconName)
				.padding()
				.frame(maxWidth: .infinity)
				.background(Color.white.opacity(0.2))
				.cornerRadius(12)
				.foregroundColor(.white)
			}
			.disabled(viewModel.isDownloadDisabled)
			.opacity(viewModel.isDownloadDisabled ? 0.5 : 1.0)
		}
		.padding()
		.padding(.bottom, 100)
	}
}
