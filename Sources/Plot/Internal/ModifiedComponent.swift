/**
*  Plot
*  Copyright (c) John Sundell 2021
*  MIT license, see LICENSE file for details
*/

internal struct ModifiedComponent: Component {
    var base: Component
    var deferredAttributes = [AnyAttribute]()
    var environmentOverrides = [Environment.Override]()
    var suppressesTrailingNewline = false
    var body: Component { Node.modifiedComponent(self) }
}
