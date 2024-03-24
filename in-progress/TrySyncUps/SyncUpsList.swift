import ComposableArchitecture
import SwiftUI

@Reducer
struct SyncUpsListFeature {
  @ObservableState
  struct State: Equatable {
    var syncUps: [SyncUp] = []
  }
  enum Action {
    case onDelete(_ indexSet: IndexSet)
    case syncUpTapped(id: SyncUp.ID)
    case addSyncUpButtonTapped
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .onDelete(indexSet):
        state.syncUps.remove(atOffsets: indexSet)
        return .none
      case .syncUpTapped:
        return .none
      case .addSyncUpButtonTapped:
        return .none
      }
    }
  }
}

@Observable
class SyncUpsListModel {
  var syncUps: [SyncUp] = []

  init(syncUps: [SyncUp] = []) {
    self.syncUps = syncUps
  }

  func onDelete(_ indexSet: IndexSet) {
    self.syncUps.remove(atOffsets: indexSet)
  }

  func syncUpTapped(id: SyncUp.ID) {
    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
  }

  func addSyncUpButtonTapped() {
    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
  }
}

struct SyncUpsListView: View {
  //let model: SyncUpsListModel
  let store: StoreOf<SyncUpsListFeature>

  var body: some View {
    List {
      ForEach(store.syncUps) { syncUp in
        Button {
          //model.syncUpTapped(id: syncUp.id)
          store.send(.syncUpTapped(id: syncUp.id))
        } label: {
          CardView(syncUp: syncUp)
        }
        .listRowBackground(syncUp.theme.mainColor)
      }
      .onDelete { indexSet in
        //model.onDelete(indexSet)
        store.send(.onDelete(indexSet))
      }
    }
    .toolbar {
      Button {
        //model.addSyncUpButtonTapped()
        store.send(.addSyncUpButtonTapped)
      } label: {
        Image(systemName: "plus")
      }
    }
    .navigationTitle("Daily Sync-ups")
  }
}

#Preview {
  NavigationStack {
    SyncUpsListView(
      store: Store(
        initialState: SyncUpsListFeature.State(syncUps: [.mock, .engineeringMock, .productMock])
      ) {
        SyncUpsListFeature()._printChanges()
      }
    )
  }
}

struct CardView: View {
  let syncUp: SyncUp

  var body: some View {
    VStack(alignment: .leading) {
      Text(syncUp.title)
        .font(.headline)
      Spacer()
      HStack {
        Label("\(syncUp.attendees.count)", systemImage: "person.3")
        Spacer()
        Label(syncUp.duration.formatted(.units()), systemImage: "clock")
          .labelStyle(.trailingIcon)
      }
      .font(.caption)
    }
    .padding()
    .foregroundColor(syncUp.theme.accentColor)
  }
}

struct TrailingIconLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.title
      configuration.icon
    }
  }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
  static var trailingIcon: Self { Self() }
}
