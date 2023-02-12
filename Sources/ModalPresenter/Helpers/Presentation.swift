import UIKit

public enum Presentation {
    public enum Context {
        case automatic
        case current
        case top
        case modal
        case root
        case globalTop
        case globalNonModalTop
    }

    static func present(
        modal hc: UIViewController,
        from uiViewController: UIViewController,
        context: Context = .automatic,
        animated: Bool = false,
        completion: @escaping () -> Void
    ) {
        switch context {
        case .current:
            uiViewController.present(hc, animated: animated, completion: completion)
        case .top:
            guard let topViewController = uiViewController.navigationController?.topViewController else { return }
            topViewController.present(hc, animated: animated, completion: completion)
        case .modal:
            guard let modalViewController = uiViewController.presentingViewController?.presentedViewController else { return }
            modalViewController.present(hc, animated: animated, completion: completion)
        case .root:
            guard let rootViewController = uiViewController.view.window?.rootViewController else { return }
            rootViewController.present(hc, animated: animated, completion: completion)
        case .automatic:
            if let topViewController = uiViewController.navigationController?.topViewController {
                topViewController.present(hc, animated: animated, completion: completion)
            } else if let modalViewController = uiViewController.presentingViewController?.presentedViewController {
                modalViewController.present(hc, animated: animated, completion: completion)
            } else if let rootViewController = uiViewController.view.window?.rootViewController {
                rootViewController.present(hc, animated: animated, completion: completion)
            }
        case .globalTop:
            UIApplication.topViewController()?.present(hc, animated: animated, completion: completion)
        case .globalNonModalTop:
            UIApplication.nonModalTopViewController()?.present(hc, animated: animated, completion: completion)
        }
    }

    static func dismiss(
        from uiViewController: UIViewController,
        context: Context = .automatic,
        animated: Bool = false,
        completion: @escaping () -> Void
    ) {
        switch context {
        case .current:
            uiViewController.dismiss(animated: animated, completion: completion)
        case .top:
            guard let topViewController = uiViewController.navigationController?.topViewController else { return }
            topViewController.dismiss(animated: animated, completion: completion)
        case .modal:
            guard let modalViewController = uiViewController.presentingViewController?.presentedViewController else { return }
            modalViewController.dismiss(animated: animated, completion: completion)
        case .root:
            guard let rootViewController = uiViewController.view.window?.rootViewController else { return }
            rootViewController.dismiss(animated: animated, completion: completion)
        case .automatic:
            if let topViewController = uiViewController.navigationController?.topViewController {
                topViewController.dismiss(animated: animated, completion: completion)
            } else if let modalViewController = uiViewController.presentingViewController?.presentedViewController {
                modalViewController.dismiss(animated: animated, completion: completion)
            } else if let rootViewController = uiViewController.view.window?.rootViewController {
                rootViewController.dismiss(animated: animated, completion: completion)
            }
        case .globalTop:
            UIApplication.topViewController()?.dismiss(animated: animated, completion: completion)
        case .globalNonModalTop:
            UIApplication.nonModalTopViewController()?.dismiss(animated: animated, completion: completion)
        }
    }
}
