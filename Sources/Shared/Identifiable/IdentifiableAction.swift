import Foundation

public struct IdentifiableAction: Identifiable, Hashable {

    public let id: UUID
    public let action: () -> Void

    public init(id: UUID = .init(), action: @escaping () -> Void) {
        self.id = id
        self.action = action
    }

    public func callAsFunction() {
        action()
    }

    public static func == (lhs: IdentifiableAction, rhs: IdentifiableAction) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
