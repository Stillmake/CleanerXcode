//
//  ContentView.swift
//  Cleaner4Xcode
//
//  Created by Baye Wayly on 2019/9/23.
//  Copyright © 2019 Baye. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var data = AppData()
    var dataView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text(
                    LocalizedStringKey(
                        data.selectedGroup!.group.describe().summary)
                )
                .font(.footnote)
                .foregroundColor(.secondary)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)

            Divider()

            ResultsTableView(analysis: data.selectedGroup!)
                .background(Color(NSColor.underPageBackgroundColor))
        }
        .frame(minWidth: 500, minHeight: 500)
    }

    var body: some View {
        let groups = data.groups.map { $0.0 }
        let selectedColor = Color.pink.opacity(0.2)

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

                    ForEach(groups, id: \.group) { group in
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
