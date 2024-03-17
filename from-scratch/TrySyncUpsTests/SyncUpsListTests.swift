import ComposableArchitecture
import XCTest

@testable import TrySyncUps

final class SyncUpsListsTests: XCTestCase {
  @MainActor
  func testDelete() async {
    let store = TestStore(
      initialState: SyncUpsListFeature.State(
        syncUps: [.mock, .engineeringMock]
      )
    ) {
      SyncUpsListFeature()
    }

    await store.send(.onDelete([1])) {
      $0.syncUps.remove(at: 1)
    }
  }
}
