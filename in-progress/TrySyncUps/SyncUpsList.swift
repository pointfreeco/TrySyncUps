import SwiftUI

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
  let model: SyncUpsListModel

  var body: some View {
    List {
      ForEach(model.syncUps) { syncUp in
        Button {
          model.syncUpTapped(id: syncUp.id)
        } label: {
          CardView(syncUp: syncUp)
        }
        .listRowBackground(syncUp.theme.mainColor)
      }
      .onDelete { indexSet in
        model.onDelete(indexSet)
      }
    }
    .toolbar {
      Button {
        model.addSyncUpButtonTapped()
      } label: {
        Image(systemName: "plus")
      }
    }
    .navigationTitle("Daily Sync-ups")
  }
}

#Preview {
  NavigationStack {
    SyncUpsListView(model: SyncUpsListModel())
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
