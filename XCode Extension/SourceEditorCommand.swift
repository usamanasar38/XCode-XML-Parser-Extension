//
//  SourceEditorCommand.swift
//  XCode Extension
//
//  Created by Usama Nasar on 14/11/2018.
//  Copyright © 2018 Usama Nasar. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        let lines = invocation.buffer.lines;
        
        let Lines : Array = lines as NSArray as! [Any]
        
        var xmlString = ""
        
        for line  in Lines{
            xmlString = "\(xmlString)\(line)"
        }
        
        func makeXMLAttribute(name: String, stringValue: String) -> XMLNode {
            let attribute = XMLNode(kind: .attribute)
            attribute.name = name
            attribute.stringValue = stringValue
            return attribute
        }
        
        let document = try? XMLDocument(xmlString: xmlString, options: [.documentTidyXML])
        
        for node in try! document!.nodes(forXPath: "//button") {
            guard let buttonElement = node as? XMLElement else { continue }
            
            let attr1 = makeXMLAttribute(name: "customClass", stringValue: "AmazingButton")
            let attr2 = makeXMLAttribute(name: "customModule", stringValue: "IBComponents")
            let attr3 = makeXMLAttribute(name: "customModuleProvider", stringValue: "target")
            
            buttonElement.addAttribute(attr1)
            buttonElement.addAttribute(attr2)
            buttonElement.addAttribute(attr3)
        }
        
        let newXMLString = document!.xmlString(options: [.nodePrettyPrint])
        lines.removeAllObjects()
        lines.addObjects(from: [newXMLString as Any])
        
        completionHandler(nil)
    }
    
}
