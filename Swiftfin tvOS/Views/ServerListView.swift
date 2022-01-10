//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import CoreStore
import SwiftUI

struct ServerListView: View {

	@EnvironmentObject
	var serverListRouter: ServerListCoordinator.Router
	@ObservedObject
	var viewModel: ServerListViewModel

	@ViewBuilder
	private var listView: some View {
		ScrollView {
			LazyVStack {
				ForEach(viewModel.servers, id: \.id) { server in
					Button {
						serverListRouter.route(to: \.userList, server)
					} label: {
						HStack {
							Image(systemName: "server.rack")
								.font(.system(size: 72))
								.foregroundColor(.primary)

							VStack(alignment: .leading, spacing: 5) {
								Text(server.name)
									.font(.title2)
									.foregroundColor(.primary)

								Text(server.currentURI)
									.font(.footnote)
									.disabled(true)
									.foregroundColor(.secondary)

								Text(viewModel.userTextFor(server: server))
									.font(.footnote)
									.foregroundColor(.primary)
							}

							Spacer()
						}
					}
					.padding(.horizontal, 100)
					.contextMenu {
						Button(role: .destructive) {
							viewModel.remove(server: server)
						} label: {
                            Label(L10n.remove, systemImage: "trash")
						}
					}
				}
			}
			.padding(.top, 50)
		}
		.padding(.top, 50)
	}

	@ViewBuilder
	private var noServerView: some View {
		VStack {
            L10n.connectToJellyfinServerStart.text
				.frame(minWidth: 50, maxWidth: 500)
				.multilineTextAlignment(.center)
				.font(.body)

			Button {
				serverListRouter.route(to: \.connectToServer)
			} label: {
				L10n.connect.text
					.bold()
					.font(.callout)
					.padding(.vertical)
					.padding(.horizontal, 30)
					.background(Color.jellyfinPurple)
			}
			.padding(.top, 40)
			.buttonStyle(CardButtonStyle())
		}
	}

	@ViewBuilder
	private var innerBody: some View {
		if viewModel.servers.isEmpty {
			noServerView
				.offset(y: -50)
		} else {
			listView
		}
	}

	@ViewBuilder
	private var trailingToolbarContent: some View {
		if viewModel.servers.isEmpty {
			EmptyView()
		} else {
			Button {
				serverListRouter.route(to: \.connectToServer)
			} label: {
				Image(systemName: "plus.circle.fill")
			}
			.contextMenu {
				Button {
					serverListRouter.route(to: \.basicAppSettings)
				} label: {
                    L10n.settings.text
				}
			}
		}
	}

	var body: some View {
		innerBody
            .navigationTitle(L10n.servers)
			.toolbar {
				ToolbarItemGroup(placement: .navigationBarTrailing) {
					trailingToolbarContent
				}
			}
			.onAppear {
				viewModel.fetchServers()
			}
	}
}
