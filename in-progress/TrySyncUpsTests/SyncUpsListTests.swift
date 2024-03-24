import ComposableArchitecture
import XCTest

@testable import TrySyncUps

final class SyncUpsListTests: XCTestCase {
  @MainActor
  func testBasics() async {
    let store = TestStore(initialState: SyncUpsListFeature.State(syncUps: [.mock, .productMock])) {
      SyncUpsListFeature()
    }
    await store.send(.onDelete([1])) {
      $0.syncUps.remove(at: 1)
    }
  }

  @MainActor
  func testModel() {
    let model = SyncUpsListModel(syncUps: [.mock, .productMock])
    model.onDelete([1])
//    XCTAssertEqual(model.syncUps, [.mock])
  }
}
