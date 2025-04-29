//
//  ToastModifier.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 29/04/2025.
//

import SwiftUI

/// A custom view modifier that displays a toast message overlay at the bottom of the screen.
/// The toast supports auto-dismissal and custom appearance for error vs. success states.
struct ToastModifier: ViewModifier {

	// MARK: - Parameters

	/// Binding to control the presentation of the toast.
	@Binding var isPresented: Bool

	/// The message text displayed inside the toast.
	var message: String

	/// Indicates whether the toast represents an error (affects style).
	var isError: Bool

	/// Duration (in seconds) before the toast automatically disappears.
	var duration: Double

	// MARK: - View Composition

	func body(content: Content) -> some View {
		ZStack(alignment: .bottom) {
			content

			if isPresented {
				ToastMessage(
					message: message,
					isError: isError,
					onDismiss: {
						withAnimation { isPresented = false }
					}
				)
				.onAppear {
					DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
						withAnimation {
							isPresented = false
						}
					}
				}
			}
		}
		.animation(.easeInOut, value: isPresented)
	}
}

// MARK: - Toast Extension

extension View {

	/// Adds a toast message to the current view.
	///
	/// - Parameters:
	///   - isPresented: A binding that controls when the toast is visible.
	///   - message: The message to display inside the toast.
	///   - isError: Whether the toast indicates an error (affects icon and color).
	///   - duration: Duration before the toast automatically disappears (default: `12`).
	///
	/// - Returns: A view with toast overlay behavior applied.
	func toast(
		isPresented: Binding<Bool>,
		message: String,
		isError: Bool,
		duration: Double = 12
	) -> some View {
		self.modifier(
			ToastModifier(
				isPresented: isPresented,
				message: message,
				isError: isError,
				duration: duration
			)
		)
	}
}
