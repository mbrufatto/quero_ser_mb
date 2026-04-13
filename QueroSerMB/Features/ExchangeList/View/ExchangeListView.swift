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
            List {
                ForEach(viewModel.exchanges) { exchange in
                    ExchangeRowView(exchange: exchange)
                        .onAppear {
                            if exchange.id == viewModel.exchanges.last?.id {
                                Task {
                                    await viewModel.loadExchanges()
                                }
                            }
                        }
                }
                
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .navigationTitle("Exchanges")
            .task {
                 await viewModel.loadExchanges()
            }
        }
    }
}

#Preview {
    ExchangeListView()
}
