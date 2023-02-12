import SwiftUI
import Combine

extension View {
    @ViewBuilder func onChange<T: Equatable>(_ value: T, perform: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            onChange(of: value, perform: perform)
        } else {
            onReceive(Just(value)) {
                perform($0)
            }
        }
    }
}
