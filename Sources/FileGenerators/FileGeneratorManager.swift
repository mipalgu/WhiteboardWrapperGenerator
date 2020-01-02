/**                                                                     
 *  /file FileGeneratorManager.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

import DataStructures
import Protocols

final public class FileGeneratorManager {

    var tsl: TSL

    var msgEnumHeaderGenerator: MsgEnumHeaderGenerator

    var cPlusPlusWBTemplateWrapperGenerator: CPlusPlusWBTemplateWrapperGenerator
    var cPlusPlusWBTemplateFunctorGenerator: CPlusPlusWBTemplateFunctorGenerator

    var cPlusPlusWBPosterGenerator: CPlusPlusWBPosterGenerator
    var cPlusPlusWBGetterGenerator: CPlusPlusWBGetterGenerator

    var cMsgSerialiseGenerator: CMsgSerialiseGenerator
    var cMsgDeserialiseGenerator: CMsgDeserialiseGenerator

    var cTypeStringLookupGenerator: CTypeStringLookupGenerator

    var cMsgHeaderIncludesGenerator: CMsgHeaderIncludesGenerator

    public init(tsl: TSL, wbPath: URL) {
        self.tsl = tsl
        msgEnumHeaderGenerator = MsgEnumHeaderGenerator(path: wbPath)

        cPlusPlusWBTemplateWrapperGenerator = CPlusPlusWBTemplateWrapperGenerator(path: wbPath)
        cPlusPlusWBTemplateFunctorGenerator = CPlusPlusWBTemplateFunctorGenerator(path: wbPath)

        cPlusPlusWBPosterGenerator = CPlusPlusWBPosterGenerator(path: wbPath)
        cPlusPlusWBGetterGenerator = CPlusPlusWBGetterGenerator(path: wbPath)

        cMsgSerialiseGenerator = CMsgSerialiseGenerator(path: wbPath)
        cMsgDeserialiseGenerator = CMsgDeserialiseGenerator(path: wbPath)

        cTypeStringLookupGenerator = CTypeStringLookupGenerator(path: wbPath)

        cMsgHeaderIncludesGenerator = CMsgHeaderIncludesGenerator(path: wbPath)
    }

    public func generate() {
        msgEnumHeaderGenerator.generate(from: tsl) 

        cPlusPlusWBTemplateWrapperGenerator.generate(from: tsl) 
        cPlusPlusWBTemplateFunctorGenerator.generate(from: tsl) 

        cPlusPlusWBPosterGenerator.generate(from: tsl) 
        cPlusPlusWBGetterGenerator.generate(from: tsl) 

        cMsgSerialiseGenerator.generate(from: tsl) 
        cMsgDeserialiseGenerator.generate(from: tsl) 

        cTypeStringLookupGenerator.generate(from: tsl) 

        cMsgHeaderIncludesGenerator.generate(from: tsl) 
    }
  
    public func updateNongenerated(wbPath: URL) {
      if tsl.useCustomNamespace {
        // Adust non-generated files.
        var filePath = wbPath.appendingPathComponent("gusimplewhiteboard.c")
        // Need to make EOL separator cross-platform conformant.
        do {
          let guSWBCin : String = try String(contentsOf: filePath, encoding: .utf8)
          var guSWBCLines = guSWBCin.components(separatedBy: "\n")
          for i in 0..<guSWBCLines.count {
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "< GSW_NUM_TYPES_DEFINED)", with: "< " + tsl.wbNamespace.uppercased() + "_GSW_NUM_TYPES_DEFINED)")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "wbd, WBTypes_stringValues[i]", with: "wbd, " + tsl.wbNamespace + "_WBTypes_stringValues[i]")
          }
          let guSWBCout = guSWBCLines.joined(separator: "\n")
          try guSWBCout.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
          print("Error:  Could not read gusimplewhiteboard.c in the custom WB build directory.")
        }
        filePath = wbPath.appendingPathComponent("guwhiteboardposter.h")
        // Need to make EOL separator cross-platform conformant.
        do {
          let guSWBCin : String = try String(contentsOf: filePath, encoding: .utf8)
          var guSWBCLines = guSWBCin.components(separatedBy: "\n")
          var alreadyUpdated = false
          for i in 0..<guSWBCLines.count {
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#ifndef gusimplewhiteboard_guwhiteboardposter_h", with: "#ifndef " + tsl.wbNamespace + "_gusimplewhiteboard_guwhiteboardposter_h")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#define gusimplewhiteboard_guwhiteboardposter_h", with: "#define " + tsl.wbNamespace + "_gusimplewhiteboard_guwhiteboardposter_h")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "bool whiteboard_post", with: "bool " + tsl.wbNamespace + "_whiteboard_post")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "bool whiteboard_post_to", with: "bool " + tsl.wbNamespace + "_whiteboard_post_to")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "bool whiteboard_postmsg", with: "bool " + tsl.wbNamespace + "_whiteboard_postmsg")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "bool whiteboard_postmsg_to", with: "bool " + tsl.wbNamespace + "_whiteboard_postmsg_to")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "int whiteboard_type_for_message_named", with: "int " + tsl.wbNamespace + "_whiteboard_type_for_message_named")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "guWhiteboard::WBTypes", with: "guWhiteboard::" + tsl.wbNamespace + "::" + tsl.wbNamespace + "_WBTypes")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "WBTypes whiteboard_type_for_message_named", with: "WBTypes " + tsl.wbNamespace + "_whiteboard_type_for_message_named")
            if ((i < guSWBCLines.count-2) && !(guSWBCLines[i+2].contains(tsl.wbNamespace))) {
              guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "namespace guWhiteboard", with: "namespace guWhiteboard\n{\nnamespace " + tsl.wbNamespace)
            } else {
              alreadyUpdated = true
            }
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "whiteboard_types_map types_map", with: "whiteboard_types_map " + tsl.wbNamespace + "_types_map")
            if (!alreadyUpdated) {
              guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#endif // __cplusplus", with: "}\n#endif // __cplusplus")
              if (i == guSWBCLines.count-2) {
                guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#endif", with: "#endif //" + tsl.wbNamespace + "_gusimplewhiteboard_guwhiteboardposter_h")
              }
            }
          }
          let guSWBCout = guSWBCLines.joined(separator: "\n")
          try guSWBCout.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
          print("Error:  Could not read guwhiteboardposter.h in the custom WB build directory.")
        }
        filePath = wbPath.appendingPathComponent("guwhiteboardgetter.h")
        // Need to make EOL separator cross-platform conformant.
        do {
          let guSWBCin : String = try String(contentsOf: filePath, encoding: .utf8)
          var guSWBCLines = guSWBCin.components(separatedBy: "\n")
          var alreadyUpdated = false
          for i in 0..<guSWBCLines.count {
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#ifndef gusimplewhiteboard_guwhiteboardgetter_h", with: "#ifndef " + tsl.wbNamespace + "_gusimplewhiteboard_guwhiteboardgetter_h")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#define gusimplewhiteboard_guwhiteboardgetter_h", with: "#define " + tsl.wbNamespace + "_gusimplewhiteboard_guwhiteboardgetter_h")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "char *whiteboard_get", with: "char *" + tsl.wbNamespace + "_whiteboard_get")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "char *whiteboard_get_from", with: "char *" + tsl.wbNamespace + "whiteboard_get_from")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "char *whiteboard_getmsg", with: "char *" + tsl.wbNamespace + "whiteboard_getmsg")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "char *whiteboard_getmsg_from", with: "char *" + tsl.wbNamespace + "whiteboard_getmsg_from")
            if ((i < guSWBCLines.count-2) && !(guSWBCLines[i+2].contains(tsl.wbNamespace))) {
              guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "namespace guWhiteboard", with: "namespace guWhiteboard\n{\nnamespace " + tsl.wbNamespace)
            } else {
              alreadyUpdated = true
            }
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "guWhiteboard::WBTypes", with: "guWhiteboard::" + tsl.wbNamespace + "::" + tsl.wbNamespace + "_WBTypes")
            if (!alreadyUpdated) {
              guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#endif // __cplusplus", with: "}\n#endif // __cplusplus")
              if (i == guSWBCLines.count-2) {
                guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#endif", with: "#endif //" + tsl.wbNamespace + "_gusimplewhiteboard_guwhiteboardgetter_h")
              }
            }
          }
          let guSWBCout = guSWBCLines.joined(separator: "\n")
          try guSWBCout.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
          print("Error:  Could not read guwhiteboardgetter.h in the custom WB build directory.")
        }
        filePath = wbPath.appendingPathComponent("WBFunctor.h")
        // Need to make EOL separator cross-platform conformant.
        do {
          let guSWBCin : String = try String(contentsOf: filePath, encoding: .utf8)
          var guSWBCLines = guSWBCin.components(separatedBy: "\n")
          for i in 0..<guSWBCLines.count {
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#ifndef WBFUNCTOR_H", with: "#ifndef " + tsl.wbNamespace.uppercased() + "_WBFUNCTOR_H")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#define WBFUNCTOR_H", with: "#define " + tsl.wbNamespace.uppercased() + "_WBFUNCTOR_H")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "guWhiteboard::WBTypes", with: "guWhiteboard::" + tsl.wbNamespace + "::" + tsl.wbNamespace + "_WBTypes")
            if (i == guSWBCLines.count-2) {
              guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#endif", with: "#endif //" + tsl.wbNamespace.uppercased() + "_WBFUNCTOR_H")
            }
          }
          let guSWBCout = guSWBCLines.joined(separator: "\n")
          try guSWBCout.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
          print("Error:  Could not read WBFunctor.h in the custom WB build directory.")
        }
        filePath = wbPath.appendingPathComponent("guwhiteboardwatcher.h")
        // Need to make EOL separator cross-platform conformant.
        do {
          let guSWBCin : String = try String(contentsOf: filePath, encoding: .utf8)
          var guSWBCLines = guSWBCin.components(separatedBy: "\n")
          for i in 0..<guSWBCLines.count {
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#ifndef GENERIC_WB_WATCHER_H", with: "#ifndef " + tsl.wbNamespace.uppercased() + "_GENERIC_WB_WATCHER_H")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#define GENERIC_WB_WATCHER_H", with: "#define " + tsl.wbNamespace.uppercased() + "_GENERIC_WB_WATCHER_H")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "guWhiteboard::WBTypes", with: "guWhiteboard::" + tsl.wbNamespace + "::" + tsl.wbNamespace + "_WBTypes")
            guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "= guWhiteboard::kwb_reserved_SubscribeToAllTypes_v)", with: "= guWhiteboard::" + tsl.wbNamespace + "::" + tsl.wbNamespace + "_kwb_reserved_SubscribeToAllTypes_v)")

            if (i == guSWBCLines.count-2) {
              guSWBCLines[i] = guSWBCLines[i].replacingOccurrences(of: "#endif", with: "#endif //" + tsl.wbNamespace.uppercased() + "_GENERIC_WB_WATCHER_H")
            }
          }
          let guSWBCout = guSWBCLines.joined(separator: "\n")
          try guSWBCout.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
          print("Error:  Could not read guwhiteboardwatcher.h in the custom WB build directory.")
        }
      }
    }
}

