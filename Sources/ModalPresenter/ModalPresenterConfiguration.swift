import UIKit

public struct ModalPresenterConfiguration {
    let backgroundColor: UIColor
    let context: Presentation.Context
    let animated: Bool
    let modalPresentationStyle: UIModalPresentationStyle
    let modalTransitionStyle: UIModalTransitionStyle
    let configurePresentedViewController: (UIViewController) -> Void

    public init(
        animated: Bool = true,
        context: Presentation.Context = .automatic,
        backgroundColor: UIColor = .clear,
        modalPresentationStyle: UIModalPresentationStyle = .overFullScreen,
        modalTransitionStyle: UIModalTransitionStyle = .crossDissolve,
        configurePresentedViewController: @escaping (UIViewController) -> Void = { _ in }
    ) {
        self.animated = animated
        self.context = context
        self.backgroundColor = backgroundColor
        self.modalPresentationStyle = modalPresentationStyle
        self.modalTransitionStyle = modalTransitionStyle
        self.configurePresentedViewController = configurePresentedViewController
    }
}
