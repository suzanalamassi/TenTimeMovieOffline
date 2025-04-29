//
//  DownloadsView.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import SwiftUI

/// A view that displays the list of downloaded movies, including their status and progress.
struct DownloadMovieList: View {

	/// View model managing the list of downloaded movies.
	@StateObject private var viewModel = DownloadMovieListViewModel()

	// MARK: - Body

	var body: some View {
		ZStack {
			if viewModel.movies.isEmpty {
				// Placeholder when there are no downloads
				MessagePlaceholderView(
					systemImageName: "square.and.arrow.down",
					message: "No downloaded videos yet."
				)
			} else {
				List {
					ForEach(viewModel.movies) { movie in
						NavigationLink(destination: MovieDetailView(movie: movie)) {
							HStack {
								// Movie thumbnail
								CachedAsyncImage(url: movie.thumbnailURL)
									.frame(width: 60, height: 60)
									.cornerRadius(8)

								// Movie title and download status
								VStack(alignment: .leading, spacing: 5) {
									Text(movie.title)
										.font(.headline)
										.foregroundColor(.white)

									HStack {
										Text(movie.downloadStatus.textDescription)
											.font(.subheadline)
											.foregroundColor(.gray)

										if movie.downloadStatus == .downloading {
											Text("(\(Int(movie.downloadPercentage))%)")
												.font(.subheadline)
												.foregroundColor(.gray)
										}
									}
								}

								Spacer()

								// Download status icon
								Image(systemName: movie.downloadStatus.iconName)
									.foregroundColor(.gray)
							}
							.padding(.vertical, 8)
						}
					}
					.onDelete { indexSet in
						for index in indexSet {
							viewModel.deleteDownloadedMovie(at: viewModel.movies[index])
						}
					}
				}
			}
		}
		.preferredColorScheme(.dark)
		.navigationBarTitleDisplayMode(.large)
		.navigationTitle("Downloads")
	}
}
