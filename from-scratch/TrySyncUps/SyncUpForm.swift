import SwiftUI

struct SyncUpFormView: View {
  @Binding var syncUp: SyncUp

  var body: some View {
    Form {
      Section {
        TextField("Title", text: $syncUp.title)
        HStack {
          Slider(value: $syncUp.duration.minutes, in: 5...30, step: 1) {
            Text("Length")
          }
          Spacer()
          Text(syncUp.duration.formatted(.units()))
        }
        ThemePicker(selection: $syncUp.theme)
      } header: {
        Text("Sync-up Info")
      }
      Section {
        ForEach($syncUp.attendees) { $attendee in
          TextField("Name", text: $attendee.name)
        }
        .onDelete { indices in
          syncUp.attendees.remove(atOffsets: indices)
        }

        Button("New attendee") {
          syncUp.attendees.append(Attendee(id: UUID()))
        }
      } header: {
        Text("Attendees")
      }
    }
  }
}


#Preview {
  NavigationStack {
    SyncUpFormView(syncUp: .constant(.mock))
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
