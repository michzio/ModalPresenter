# ModalPresenter

Missing view modifier enabling full screen modal presentation by using underneath UIKit modal presentation. 

# Usage - Cocoapods 

```
pod 'ModalPresenter'
```

# Usage - Swift Package Manager

Once you have your Swift package set up, adding CardScanner as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```
dependencies: [
    .package(url: "https://github.com/michzio/ModalPresenter.git", .upToNextMajor(from: "0.1.0"))
]
```


# How to use 

Using .presentModal(isPresented: ...)

```
    struct ContentView: View {

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
```

Using .presentModal(item: ...)


```
   struct ContentView: View {

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
```
