//: Playground - noun: a place where people can play

import AppKit
import XCPlayground


XCPSetExecutionShouldContinueIndefinitely()

struct Store {
    var name: String
    var logoURL: NSURL
}

struct Product {
    var name: String
    var store: Store
}


struct Header {
    var storeURL: NSURL? = nil
    var storeName: String? = nil
    var productName: String? = nil
    
    init(product: Product) {
        self.storeURL = product.store.logoURL
        self.storeName = product.store.name
        self.productName = product.name
    }
}

class ProductHeaderController {
    let storeNameLabel: NSTextView = NSTextView(frame: NSRect(x: 0, y: 0, width: 100, height: 40))
    let productNameLabel: NSTextView = NSTextView(frame: NSRect(x: 0, y: 0, width: 100, height: 40))
    let storeLogoImageView: NSImageView = NSImageView(frame: NSRect(x: 0, y: 0, width: 40, height: 40))

    
    var header: Header! {
        didSet {
            print("didSet header  \(product.store.name)")
            storeNameLabel.string = header.storeName
            productNameLabel.string = header.productName
            if let storeName = header.storeName {
                storeLogoImageView.image = NSImage(named: storeName)
            } else {
                storeLogoImageView.image = nil
            }
        }
    }
    
    var product: Product! {
        didSet {
            print("didSet product")
            header = Header(product: product)
        }
    }
}


let productController = ProductHeaderController()
let store = Store(name: "Forever 21", logoURL: NSURL(string: "http://forever21.com/logo.png")!)
var product = Product(name: "Black dress", store: store)
productController.product = product
//productController.header = Header(product: product)


dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
    productController.product.store.name = "GAP"
    print(productController.storeNameLabel.string)
}

