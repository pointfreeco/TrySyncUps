import ComposableArchitecture
import SwiftUI

@main
struct SyncUpsApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        SyncUpsListView(
          store: Store(
            initialState: SyncUpsListFeature.State(
//              destination: .syncUpDetail(
//                SyncUpDetailFeature.State(
//                  //editSyncUp: SyncUpFormFeature.State(syncUp: .mock),
//                  recordMeeting: RecordMeetingFeature.State(syncUp: .mock),
//                  syncUp: Shared(.mock)
//                )
//              )
            )
          ) {
            SyncUpsListFeature()
              ._printChanges()
          }
        )
      }
    }
  }
}
