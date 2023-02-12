import SwiftUI
import Introspect

struct ItemModalPresenterViewModifier<ModalContent: View, Item: Identifiable>: ViewModifier {

    final class Coordinator: NSObject {
        weak var uiViewController: UIViewController?
    }

    @State private var coordinator = Coordinator()
    @State private var presentedItem: Item?
    @Binding private var item: Item?

    private let configuration: ModalPresenterConfiguration
    private let onDismiss: (() -> Void)?
    private let modalContent: (Item) -> ModalContent

    init(
        item: Binding<Item?>,
        configuration: ModalPresenterConfiguration = .init(),
        onDismiss: (() -> Void)? = nil,
        modalContent: @escaping (Item) -> ModalContent
    ) {
        self.configuration = configuration
        self.onDismiss = onDismiss
        self.modalContent = modalContent

        _item = item
    }

    func body(content: Content) -> some View {
        content
            .background(
                ItemModalPresenter(item: $presentedItem, configuration: configuration, onDismiss: onDismiss, content: modalContent)
                    .introspectViewController { viewController in
                        coordinator.uiViewController = viewController
                    }
            )
            .onAppear {
                presentedItem = item
            }
            .onChange(item?.id) { _ in
                if presentedItem != nil, let item {
                    presentedItem = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(350)) {
                        presentedItem = item
                    }
                } else {
                    presentedItem = item
                }
            }
            .onDisappear {
                guard item != nil else { return }
                item = nil
                presentedItem = nil

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
    func presentModal<Content, T>(
        item: Binding<T?>,
        configuration: ModalPresenterConfiguration = .init(),
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (T) -> Content
    ) -> some View where Content: View, T: Identifiable {
        modifier(ItemModalPresenterViewModifier(item: item, configuration: configuration, onDismiss: onDismiss, modalContent: content))
    }

    func presentModal<Content, T>(
        item: Binding<T?>,
        configuration: ModalPresenterConfiguration = .init(),
        dismissAction: Binding<IdentifiableAction?>,
        @ViewBuilder content: @escaping (T) -> Content
    ) -> some View where Content: View, T: Identifiable {
        let onDismiss = {
            guard let action = dismissAction.wrappedValue else { return }
            action()
            dismissAction.wrappedValue = nil
        }
        return presentModal(item: item, configuration: configuration, onDismiss: onDismiss, content: content)
    }
}

struct ItemModalPresenterViewModifier_Previews: PreviewProvider {

    private struct Item: Identifiable {
        let id: String
    }

    private struct ContentView: View {

        @State private var presentedItem: Item?

        var body: some View {
            ZStack {
                Button("Show modal") {
                    presentedItem = .init(id: "Modal text")
                }
            }
            .presentModal(item: $presentedItem) { item in
                VStack {
                    Text(item.id)

                    Button("Show new modal") {
                        presentedItem = .init(id: "New modal text")
                    }
                }
            }
        }
    }

    static var previews: some View {
        ContentView()
    }
}
