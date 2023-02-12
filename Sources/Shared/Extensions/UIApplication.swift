import UIKit
import SwiftUI

extension UIApplication {

    class var activeScene: UIWindowScene? {
        for scene in UIApplication.shared.connectedScenes {
            if scene.activationState == .foregroundActive {
                return (scene as? UIWindowScene)
            }
        }
        return nil
    }

    class var activeSceneDelegate: UIWindowSceneDelegate? {
        (Self.activeScene)?.delegate as? UIWindowSceneDelegate
    }

    class var activeSceneRootViewController: UIViewController? {

        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                if scene.activationState == .foregroundActive {
                    return ((scene as? UIWindowScene)?.delegate as? UIWindowSceneDelegate)?.window??.rootViewController
                }
            }

        } else {
            // Fallback on earlier versions
            return UIApplication.shared.keyWindow?.rootViewController
        }

        return nil
    }
}

extension UIApplication {

    class func topViewController(controller: UIViewController? = UIApplication.activeSceneRootViewController) -> UIViewController? {

        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.topViewController ?? navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }

        if let navigationController = controller?.children.first as? UINavigationController {

            return topViewController(controller: navigationController.topViewController ?? navigationController.visibleViewController)
        }

        return controller
    }

    class func nonModalTopViewController(controller: UIViewController? = UIApplication.activeSceneRootViewController) -> UIViewController? {

        print(controller ?? "nil")

        if let navigationController = controller as? UINavigationController {
            return nonModalTopViewController(controller: navigationController.topViewController ?? navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return nonModalTopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            let top = nonModalTopViewController(controller: presented)
            if top == presented { // just modal
                return controller
            } else {
                print("Top:", top ?? "nil")
                return top
            }
        }

        if let navigationController = controller?.children.first as? UINavigationController {

            return nonModalTopViewController(controller: navigationController.topViewController ?? navigationController.visibleViewController)
        }

        return controller
    }
}
