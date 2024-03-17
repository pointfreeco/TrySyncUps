import ComposableArchitecture
import SwiftUI

@Reducer
struct SyncUpsListFeature {
  @ObservableState
  struct State: Equatable {
    var syncUps: IdentifiedArrayOf<SyncUp> = []
  }
  enum Action {
    case onDelete(IndexSet)
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .onDelete(indexSet):
        state.syncUps.remove(atOffsets: indexSet)
        return .none
      }
    }
  }
}

@Observable
class SyncUpsModel {
  var syncUps: IdentifiedArrayOf<SyncUp> = []
  func onDelete(_ indexSet: IndexSet) {
  }
}

struct SyncUpsListView: View {
  let store: StoreOf<SyncUpsListFeature>
  //let model: SyncUpsModel

  var body: some View {
    List {
      ForEach(store.syncUps) { syncUp in
        Button {
          /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
        } label: {
          CardView(syncUp: syncUp)
        }
        .listRowBackground(syncUp.theme.mainColor)
      }
      .onDelete { indexSet in
        store.send(.onDelete(indexSet))
        //model.onDelete(indexSet)
      }
    }
    .toolbar {
      Button {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
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
        initialState: SyncUpsListFeature.State(
          syncUps: [.mock, .productMock, .engineeringMock]
        )
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
