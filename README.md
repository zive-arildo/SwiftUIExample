# SwiftUIExample

A compact SwiftUI sample app that fetches and displays GitHub repositories using the GitHub Search API. The project demonstrates modern SwiftUI patterns (async/await networking, `NavigationStack`, `AsyncImage`, and a lightweight MVVM-style ViewModel).

## Features
- Fetch repositories from the GitHub Search API.
- Async/await networking in the `ViewModel`.
- Pull-to-refresh with `.refreshable`.
- Loading, empty and error UI states.
- Tappable rows that navigate to a `DetailView` showing repository details.
- Owner avatar images with `AsyncImage`.
- Safe optional handling and basic error handling.

## Project structure
- `SwiftUIExample/`
  - `ContentView.swift` — main list UI with loading/error/empty states and repo rows
  - `DetailView.swift` — repository detail screen (avatar, description, stats, open-in-GitHub)
  - `SwiftUIExampleApp.swift` — app entry point
  - `Utils/Constants.swift` — API base URL and search endpoint
  - `Model/`
    - `SearchRepositoryResponse.swift` — top-level search response model
    - `RepositoryResponse.swift` — repository model (conforms to `Identifiable`)
    - `OwnerResponse.swift` — owner model
    - `LoadingState.swift` — loading state enum
  - `ViewModel/ViewModel.swift` — networking and `@Published` state management (async/await)
  - `Assets.xcassets`, tests, and Xcode project files

## Requirements
- Xcode 14+ (recommended) or newer
- iOS 16+ (uses `NavigationStack`, `AsyncImage`, and async/await)
- Swift concurrency (async/await) support

## Quick start
1. Open the project in Xcode:

```bash
open SwiftUIExample.xcodeproj
```

2. Pick a simulator or device and run (Cmd+R).

### Run tests (optional)
Run tests from Xcode (Cmd+U) or via `xcodebuild`:

```bash
xcodebuild -scheme SwiftUIExample -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 14' test
```

(Adjust the destination device name as needed.)

## Configuration
- API endpoints are defined in `Utils/Constants.swift`:
  - `Constants.baseUrl` (default: `https://api.github.com/`)
  - `Constants.searchRepoUrl`
- The `ViewModel` composes query parameters for the GitHub search endpoint (sort, order, and search qualifiers). Modify `ViewModel` to change default queries.

## Implementation notes
- Networking uses `async/await` in `ViewModel.fetchRepositories()` and sets `@Published` state on the main actor.
- The synthesized `Decodable` initializers in this project context are main-actor-isolated; decoding is performed from the main actor to avoid Swift 6 actor-isolation errors. If you expect large payloads, consider decoding on a background thread by either:
  - Implementing a `nonisolated init(from:)` for the model types (manual decoding), or
  - Decoding into a nonisolated DTO and mapping to main-actor types afterwards.

## Performance notes
- List identity: `RepositoryResponse` conforms to `Identifiable` using the GitHub `id: Int`. This gives SwiftUI a stable identity for diffing. Avoid generating ephemeral IDs (e.g., `UUID()` per render) as that forces row re-creation.
- For very large responses, prefer background decoding and mapping to UI models to avoid blocking the main thread.
- `AsyncImage` provides basic caching; for production use consider a dedicated image caching solution.

## UX / accessibility suggestions
- Add `accessibilityLabel` and `accessibilityValue` for rows and buttons.
- Use `.redacted(reason: .placeholder)` or skeleton views during loading for better perceived performance.
- Add `.searchable` to the list to allow user queries.

## Future improvements
- In-app browser (SFSafariViewController) to open repository pages without leaving the app.
- Share button on `DetailView` to share repository links.
- Dependency injection for `URLSession`/`JSONDecoder` to improve testability.
- Favorites/bookmarks persisted locally.
- Detailed error mapping and retry/backoff strategies.

## Contributing
- Open issues or PRs. Keep changes focused and add tests where applicable.
- If you'd like, I can implement any of the suggested improvements (ex: in-app browser, search, DI for networking) and add tests.

---

This README was generated/updated on request. If you'd like a shorter or longer version, or a README tailored for a specific audience (hiring manager, open-source users, or internal team), tell me which style and I'll adjust it.
