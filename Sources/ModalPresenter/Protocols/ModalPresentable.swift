import Foundation

protocol ModalPresentable: AnyObject {
    var dismissHandler: () ->  Void { get set }
}
