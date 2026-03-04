//
//  ContentView.swift
//  Cleaner4Xcode
//
//  Created by Baye Wayly on 2019/9/23.
//  Copyright © 2019 Baye. All rights reserved.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @ObservedObject var data = AppData()

    private func command(for group: AnalysisGroup) -> String? {
        switch group {
        case .simulators:
            return "xcrun simctl delete unavailable"
        case .previews:
            return "xcrun simctl --set previews delete unavailable"
        default:
            return nil
        }
    }

    private func copyCommandToPasteboard(_ command: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(command, forType: .string)
    }

    var dataView: some View {
        VStack(alignment: .leading, spacing: 0) {
            let selectedGroup = data.selectedGroup!
            let summaryKey = selectedGroup.group.describe().summary
            let command = command(for: selectedGroup.group)
            HStack(alignment: .top) {
                Text(
                    LocalizedStringKey(summaryKey)
                )
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)

                if let command {
                    Button("Copy Command") {
                        copyCommandToPasteboard(command)
                    }
                    .font(.caption)
                    .buttonStyle(.borderedProminent)
                    .tint(.pink.opacity(0.5))
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)

            Divider()

            ResultsTableView(analysis: selectedGroup)
                .background(Color(NSColor.underPageBackgroundColor))
        }
        .frame(minWidth: 500, minHeight: 500)
    }

    let selectedColor = Color.pink.opacity(0.2)

    var body: some View {
        NavigationSplitView {
            ScrollView {
                VStack(spacing: 4) {
                    Button {
                        self.data.selectedGroup = nil
                    } label: {
                        Text("sidebar.welcome")
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .frame(minWidth: 80, maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .background(self.data.selectedGroup === nil ? selectedColor : nil)
                            .clipShape(.rect(cornerRadius: 8))
                    }
                    .buttonStyle(.noAnimation)

                    ForEach(data.groups.map { $0.0 }, id: \.group) { group in
                        Button {
                            if self.data.selectedGroup !== group {
                                self.data.selectedGroup = group
                            }
                        } label: {
                            AnalysisView(analysis: group)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .contentShape(Rectangle())
                                .background(self.data.selectedGroup === group ? selectedColor : nil)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                        .buttonStyle(.noAnimation)
                    }
                }
                .padding(12)
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 240, max: 350)
        } detail: {
            if data.selectedGroup == nil {
                WelcomeView()
                    .navigationTitle("Cleaner for Xcode")
                    .toolbar {
                        EmptyView()
                    }
                    .environmentObject(data)

            } else {
                dataView
                    .environmentObject(data)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
