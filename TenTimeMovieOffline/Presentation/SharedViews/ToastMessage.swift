//
//  ToastMessage.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 29/04/2025.
//

import SwiftUI

/// A reusable toast message view to display brief alerts, such as connectivity status.
/// Supports drag-to-dismiss and manual dismissal with a close button.
struct ToastMessage: View {

	// MARK: - Properties

	/// The message text displayed in the toast.
	var message: String

	/// Indicates whether the toast represents an error state.
	var isError: Bool

	/// Optional closure called when the toast is dismissed.
	var onDismiss: (() -> Void)? = nil

	/// Vertical offset used to animate drag gestures.
	@State private var offsetY: CGFloat = 0

	// MARK: - Body

	var body: some View {
		VStack {
			HStack {
				Image(systemName: isError ? "wifi.exclamationmark" : "wifi")
					.foregroundColor(.white)

				Text(message)
					.foregroundColor(.white)
					.fontWeight(.semibold)
					.font(.system(size: 14))

				Spacer()

				// Close button
				Button(action: {
					withAnimation {
						onDismiss?()
					}
				}) {
					Image(systemName: "xmark")
						.resizable()
						.scaledToFit()
						.foregroundColor(.white)
						.frame(width: 10)
						.padding(8)
				}
			}
			.padding(.horizontal)
			.padding(.vertical, 10)
			.background(isError ? Color(hex: "A11717") : Color(hex: "09932C"))
			.cornerRadius(30)
			.shadow(radius: 5)
			.padding(.horizontal, 10)

			// Drag to dismiss
			.offset(y: offsetY)
			.gesture(
				DragGesture()
					.onChanged { value in
						if value.translation.height > 0 {
							offsetY = value.translation.height
						}
					}
					.onEnded { value in
						if value.translation.height > 40 {
							withAnimation {
								onDismiss?()
							}
						} else {
							withAnimation {
								offsetY = 0
							}
						}
					}
			)
			.transition(.move(edge: .bottom).combined(with: .opacity))
			.transition(.move(edge: .top).combined(with: .opacity))
		}
		.padding(.horizontal, 30)
	}
}
