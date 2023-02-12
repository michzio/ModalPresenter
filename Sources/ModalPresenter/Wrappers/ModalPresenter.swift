import SwiftUI

struct ModalPresenter<Content>: UIViewControllerRepresentable where Content: View {

    @Binding private var isPresented: Bool
    @State private var presented: UIViewController? = nil

    private let configuration: ModalPresenterConfiguration

    private let content: () -> Content
    private let onDismiss: (() -> Void)?

    init(
        isPresented: Binding<Bool>,
        configuration: ModalPresenterConfiguration = .init(),
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.configuration = configuration
        self.onDismiss = onDismiss
        self.content = content

        _isPresented = isPresented
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ModalPresenter>) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context _: UIViewControllerRepresentableContext<ModalPresenter>) {
        if isPresented {
            if let presented = presented {
                (presented as? UIHostingController)?.rootView = content()
            } else {
                let hc = ModalHostingController(rootView: content())
                hc.modalPresentationStyle = configuration.modalPresentationStyle
                hc.modalTransitionStyle = configuration.modalTransitionStyle
                hc.view.backgroundColor = .clear
                hc.dismissHandler = {
                    self.isPresented = false
                }

                configuration.configurePresentedViewController(hc)

                DispatchQueue.main.throttle(interval: 1.0, context: uiViewController) {
                    print("[DEBUG]: Presentation in context:", configuration.context)
                    Presentation.present(
                        modal: hc,
                        from: uiViewController,
                        context: configuration.context,
                        animated: configuration.animated) {
                        presented = hc
                    }
                }
            }
            
        } else {
            guard presented != nil else { return }
            DispatchQueue.main.throttle(interval: 0.1, context: uiViewController) {
                self.presented?.dismiss(animated: configuration.animated, completion: {
                    self.presented = nil
                    self.onDismiss?()
                })
            }
        }
    }
}
