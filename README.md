# A Collection of Binding Methods for MacOS

This repository contains four methods for binding state to views in MacOS.

* SimpleBindingsSwift_01 uses IBActions.
* SimpleBindingsSwift_02 creates a NSObjectController programatically.
* SimpleBindingsSwift_03 uses a NSObjectController that is embedded in the xib file.
* SimpleBindingsSwift_04 uses RxSwift/RxCocoa to setup the bindings.

I have always wondered by the RxCocoa bindings for the MacOS side are so sparse and now I see why. Cocoa has a much more elaborate binding system than UIKit out of the box so the extra bindings from RxCocoa aren't really needed.

This code was inspired by Apple's SimpleBindingsAdoption sample code. Refer to that project for more information about MacOS bindings.
