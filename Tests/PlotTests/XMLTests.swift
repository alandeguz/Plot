/**
*  Plot
*  Copyright (c) Alan DeGuzman 2026
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/

import Testing
import Plot

struct XMLTests {
    @Test func emptyXML() {
        assertEqualXMLContent(XML(), "")
    }

    @Test func singleElement() {
        let xml = XML(.element(named: "hello", text: "world!"))
        assertEqualXMLContent(xml, "<hello>world!</hello>")
    }

    @Test func selfClosingElement() {
        let xml = XML(.selfClosedElement(named: "element"))
        assertEqualXMLContent(xml, "<element>")
    }

    @Test func elementWithAttribute() {
        let xml = XML(.element(
            named: "element",
            nodes: [
                .attribute(named: "attribute", value: "value")
            ]
        ))

        assertEqualXMLContent(xml, #"<element attribute="value"></element>"#)
    }

    @Test func elementWithChildren() {
        let xml = XML(
            .element(named: "parent", nodes: [
                .selfClosedElement(named: "a"),
                .selfClosedElement(named: "b")
            ])
        )

        assertEqualXMLContent(xml, "<parent><a><b></parent>")
    }
}
