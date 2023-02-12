import SwiftUI
import Introspect

struct ModalPresenterViewModifier<ModalContent: View>: ViewModifier {

    final class Coordinator: NSObject {
        weak var uiViewController: UIViewController?
    }

    @State private var coordinator = Coordinator()
    @Binding private var isPresented: Bool

    private let configuration: ModalPresenterConfiguration
    private let onDismiss: (() -> Void)?
    private let modalContent: () -> ModalContent

    init(
        isPresented: Binding<Bool>,
        configuration: ModalPresenterConfiguration = .init(),
        onDismiss: (() -> Void)?,
        content: @escaping () -> ModalContent
    ) {
        self.configuration = configuration
        self.onDismiss = onDismiss
        self.modalContent = content

        _isPresented = isPresented
    }

    func body(content: Content) -> some View {
        content
            .background(
                ModalPresenter(isPresented: $isPresented, configuration: configuration, onDismiss: onDismiss, content: modalContent)
                    .introspectViewController { viewController in
                        coordinator.uiViewController = viewController
                    }
            )
            .onDisappear {
                guard isPresented else { return }
                isPresented = false

                guard let uiViewController = coordinator.uiViewController else { return }
                DispatchQueue.main.throttle(interval: 0.1, context: uiViewController) {
                    Presentation.dismiss(
                        from: uiViewController,
                        context: configuration.context,
                        animated: configuration.animated,
                        completion: { onDismiss?() }
                    )
                }
            }

    }
}

public extension View {
    func presentModal<Content>(
        isPresented: Binding<Bool>,
        configuration: ModalPresenterConfiguration = .init(),
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content : View {
        modifier(ModalPresenterViewModifier(isPresented: isPresented, configuration: configuration, onDismiss: onDismiss, content: content))
    }

    func presentModal<Content, T>(
        isPresented: Binding<Bool>,
        configuration: ModalPresenterConfiguration = .init(),
        dismissAction: Binding<IdentifiableAction?>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content : View {
        let onDismiss = {
            guard let action = dismissAction.wrappedValue else { return }
            action()
            dismissAction.wrappedValue = nil
        }
        return presentModal(isPresented: isPresented, configuration: configuration, onDismiss: onDismiss, content: content)
    }
}

struct ModalPresenterViewModifier_Previews: PreviewProvider {

    private struct ContentView: View {

        @State private var showModel = false

        var body: some View {
            ZStack {
                Button("Show modal") {
                    showModel = true
                }
            }
            .presentModal(isPresented: $showModel) {
                Text("Modal")
            }
        }
    }

    static var previews: some View {
        ContentView()
    }
}
