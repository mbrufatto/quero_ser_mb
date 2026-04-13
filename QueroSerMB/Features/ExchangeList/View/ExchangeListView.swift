//
//  ExchangeListView.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 10/04/26.
//

import SwiftUI

struct ExchangeListView: View {
    @StateObject private var viewModel = ExchangeListViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.filteredExchanges) { exchange in
                        NavigationLink {
                            ExchangeDetailView(viewModel: ExchangeDetailViewModel(exchange: exchange))
                        } label: {
                            ExchangeRowView(exchange: exchange)
                        }
                        .onAppear {
                            if exchange.id == viewModel.exchanges.last?.id {
                                Task { await viewModel.loadExchanges() }
                            }
                        }
                    }
                    
                    if viewModel.isLoading && !viewModel.exchanges.isEmpty {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
                .navigationTitle("Exchanges")
                .searchable(text: $viewModel.searchText, prompt: "Busca exchange")
                .task {
                    if viewModel.exchanges.isEmpty {
                        await viewModel.loadExchanges()
                    }
                }
                
                if let error = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        
                        Text(error)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(
                                Capsule()
                                    .fill(Color.red.opacity(0.9))
                                    .shadow(radius: 10)
                            )
                            .foregroundColor(.white)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        
                        Spacer()
                    }
                    .padding(.bottom, 50)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
            }
        }
    }
}
