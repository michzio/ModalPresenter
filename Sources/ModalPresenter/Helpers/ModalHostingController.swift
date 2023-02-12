import SwiftUI

class ModalHostingController<Content: View> : UIHostingController<Content>, ModalPresentable {
    var dismissHandler: () -> Void = { }
}
