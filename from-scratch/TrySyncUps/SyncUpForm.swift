import ComposableArchitecture
import SwiftUI

@Reducer
struct SyncUpFormFeature {
  @ObservableState
  struct State {
    var syncUp: SyncUp
  }
  enum Action: BindableAction {
    case binding(BindingAction<State>)
  }
  var body: some ReducerOf<Self> {
    BindingReducer()
  }
}

enum SyncUpFormField: Hashable {
  case attendee(Attendee.ID)
  case title
}

struct SyncUpFormView: View {
  @Bindable var store: StoreOf<SyncUpFormFeature>
  var body: some View {
    Form {
      Section {
        TextField("Title", text: $store.syncUp.title)
        HStack {
          Slider(value: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=15 minutes@*/.constant(Double(15))/*@END_MENU_TOKEN@*/, in: 5...30, step: 1) {
            Text("Length")
          }
          Spacer()
          Text(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=15 minutes@*/Duration.seconds(15 * 60)/*@END_MENU_TOKEN@*/.formatted(.units()))
        }
        ThemePicker(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=bubblegum@*/.constant(.bubblegum)/*@END_MENU_TOKEN@*/)
      } header: {
        Text("Sync-up Info")
      }
      Section {
        ForEach(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=$attendees@*/SyncUp.mock.attendees.map(Binding.constant)/*@END_MENU_TOKEN@*/) { $attendee in
          TextField("Name", text: $attendee.name)
        }
        .onDelete { indices in
          /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
        }

        Button("New attendee") {
          /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
        }
      } header: {
        Text("Attendees")
      }
    }
  }
}


#Preview {
  NavigationStack {
//    SyncUpFormView()
  }
}

struct ThemePicker: View {
  @Binding var selection: Theme

  var body: some View {
    Picker("Theme", selection: $selection) {
      ForEach(Theme.allCases) { theme in
        ZStack {
          RoundedRectangle(cornerRadius: 4)
            .fill(theme.mainColor)
          Label(theme.name, systemImage: "paintpalette")
            .padding(4)
        }
        .foregroundColor(theme.accentColor)
        .fixedSize(horizontal: false, vertical: true)
        .tag(theme)
      }
    }
  }
}

extension Duration {
  fileprivate var minutes: Double {
    get { Double(components.seconds / 60) }
    set { self = .seconds(newValue * 60) }
  }
}
