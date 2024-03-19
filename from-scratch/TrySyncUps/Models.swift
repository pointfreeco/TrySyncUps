import ComposableArchitecture
import SwiftUI

struct SyncUp: Equatable, Identifiable, Codable {
  let id: UUID
  var attendees: IdentifiedArrayOf<Attendee> = []
  var duration: Duration = .seconds(60 * 5)
  var meetings: IdentifiedArrayOf<Meeting> = []
  var theme: Theme = .bubblegum
  var title = ""

  var durationPerAttendee: Duration {
    duration / attendees.count
  }
}

struct Attendee: Equatable, Identifiable, Codable {
  let id: UUID
  var name = ""
}

struct Meeting: Equatable, Identifiable, Codable {
  let id: UUID
  let date: Date
  var transcript: String
}

enum Theme: String, CaseIterable, Equatable, Identifiable, Codable {
  case appIndigo
  case appMagenta
  case appOrange
  case appPurple
  case appTeal
  case yellow
  case bubblegum
  case buttercup
  case lavender
  case navy
  case oxblood
  case periwinkle
  case poppy
  case seafoam
  case sky
  case tan

  var id: Self { self }

  var accentColor: Color {
    switch self {
    case .appOrange, .appTeal, .yellow, .bubblegum, .buttercup, .lavender, .periwinkle, .poppy,
        .seafoam, .sky, .tan:
      return .black
    case .appIndigo, .appMagenta, .appPurple, .navy, .oxblood:
      return .white
    }
  }

  var mainColor: Color { Color(rawValue) }

  var name: String {
    switch self {
    case .appIndigo:
      "indigo"
    case .appMagenta:
      "magent"
    case .appOrange:
      "orange"
    case .appPurple:
      "purple"
    case .appTeal:
      "teal"
    case .yellow:
      "yellow"
    case .bubblegum:
      "bubblegum"
    case .buttercup:
      "buttercup"
    case .lavender:
      "lavender"
    case .navy:
      "navy"
    case .oxblood:
      "oxblood"
    case .periwinkle:
      "periwinkle"
    case .poppy:
      "poppy"
    case .seafoam:
      "seafoam"
    case .sky:
      "sky"
    case .tan:
      "tan"
    }
  }
}

extension SyncUp {
  static let mock = Self(
    id: SyncUp.ID(),
    attendees: [
      Attendee(id: Attendee.ID(), name: "Blob"),
      Attendee(id: Attendee.ID(), name: "Blob Jr"),
      Attendee(id: Attendee.ID(), name: "Blob Sr"),
      Attendee(id: Attendee.ID(), name: "Blob Esq"),
      Attendee(id: Attendee.ID(), name: "Blob III"),
      Attendee(id: Attendee.ID(), name: "Blob I"),
    ],
    duration: .seconds(60),
    meetings: [
      Meeting(
        id: Meeting.ID(),
        date: Date().addingTimeInterval(-60 * 60 * 24 * 7),
        transcript: """
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor \
          incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud \
          exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure \
          dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. \
          Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt \
          mollit anim id est laborum.
          """
      )
    ],
    theme: .appOrange,
    title: "Design"
  )

  static let engineeringMock = Self(
    id: SyncUp.ID(),
    attendees: [
      Attendee(id: Attendee.ID(), name: "Blob"),
      Attendee(id: Attendee.ID(), name: "Blob Jr"),
    ],
    duration: .seconds(60 * 10),
    theme: .periwinkle,
    title: "Engineering"
  )

  static let productMock = Self(
    id: SyncUp.ID(),
    attendees: [
      Attendee(id: Attendee.ID(), name: "Blob Sr"),
      Attendee(id: Attendee.ID(), name: "Blob Jr"),
    ],
    duration: .seconds(60 * 30),
    theme: .poppy,
    title: "Product"
  )
}
