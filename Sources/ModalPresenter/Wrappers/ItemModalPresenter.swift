import SwiftUI

struct ItemModalPresenter<Content, T>: UIViewControllerRepresentable where Content: View {

    @Binding private var item: T?
    @State private var presented: UIViewController? = nil

    private let content: (T) -> Content
    private let onDismiss: (() -> Void)?

    private let configuration: ModalPresenterConfiguration

    init(
        item: Binding<T?>,
        configuration: ModalPresenterConfiguration = .init(),
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.configuration = configuration
        self.onDismiss = onDismiss
        self.content = content

        _item = item
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ItemModalPresenter>) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context _: UIViewControllerRepresentableContext<ItemModalPresenter>) {
        if let item {
            if let presented = presented {
                (presented as? UIHostingController)?.rootView = content(item)
            } else {
                let hc = ModalHostingController(rootView: content(item))
                hc.modalPresentationStyle = configuration.modalPresentationStyle
                hc.modalTransitionStyle = configuration.modalTransitionStyle
                hc.view.backgroundColor = configuration.backgroundColor
                hc.dismissHandler = {
                    self.item = nil
                }

                DispatchQueue.main.throttle(interval: 5.0, context: uiViewController) {
                    print("[DEBUG]: Presentation in context:", configuration.context)
                    Presentation.present(
                        modal: hc,
                        from: uiViewController,
                        context: configuration.context,
                        animated: configuration.animated
                    ) {
                        presented = hc
                    }
                }
            }
        } else {
            guard presented != nil else { return }
            DispatchQueue.main.throttle(interval: 0.1, context: uiViewController) {
                presented?.dismiss(animated: configuration.animated, completion: {
                    presented = nil
                    onDismiss?()
                })
            }
        }
    }
}
