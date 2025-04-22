import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: JellyfinViewModel
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var viewModel: JellyfinViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Server Information")) {
                    TextField("Server URL", text: $viewModel.serverURL)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                }
                
                Section(header: Text("Credentials")) {
                    TextField("Username", text: $viewModel.username)
                        .autocapitalization(.none)
                    SecureField("Password", text: $viewModel.password)
                }
                
                Section {
                    Button(action: {
                        viewModel.connectToServer()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Connect")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
                
                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Jellyfin")
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "film")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct LibraryView: View {
    var body: some View {
        NavigationView {
            Text("Library Content")
                .navigationTitle("Library")
        }
    }
}

struct SearchView: View {
    var body: some View {
        NavigationView {
            Text("Search Content")
                .navigationTitle("Search")
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var viewModel: JellyfinViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: {
                        viewModel.logout()
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
} 