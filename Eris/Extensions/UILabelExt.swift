//
//  UILabelExt.swift
//  Eris
//
//  Created by Dmitry Chicherin on 13/10/2566 BE.
//

import Foundation
import UIKit


extension UILabel {
    //Done to type out text slowly
    func setTyping(text: String, characterDelay: TimeInterval = 5.0) {
      self.text = ""
        
      let writingTask = DispatchWorkItem { [weak self] in
        text.forEach { char in
          DispatchQueue.main.async {
            self?.text?.append(char)
          }
          Thread.sleep(forTimeInterval: characterDelay/100)
        }
      }
        
      let queue: DispatchQueue = .init(label: "typespeed", qos: .userInteractive)
      queue.asyncAfter(deadline: .now() + 0.05, execute: writingTask)
    }
    
}
