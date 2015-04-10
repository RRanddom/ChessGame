//
//  ChessView.swift
//  ChessGame
//
//  Created by apple on 15-4-10.
//  Copyright (c) 2015年 apple.com. All rights reserved.
//

import UIKit

 protocol ChessViewDelegate  {
    
     func didTouchView(view:UIView,line:Int,row:Int)
}

class ChessView :UIView {
    
    var size:CGFloat = 0.0
    var delegate:ChessViewDelegate?
    
    override func drawRect(rect: CGRect) {
        size = min(rect.size.width, rect.size.height)
        size /= 6
        var context = UIGraphicsGetCurrentContext()
        let yellowColor = UIColor(red: 1.0, green: 0.896, blue: 0.545, alpha: 1.0).CGColor
        let orangeColor = UIColor(red: 0.991, green: 0.311, blue: 0.136, alpha: 1.0).CGColor
       
        var tapGesture = UITapGestureRecognizer(target:self, action: "handleGesture:")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapGesture)
        
        for line in 0...5{
            for row in 0...5{
                if(line % 2 != 0){
                    if(row % 2 != 0){
                        CGContextSetFillColorWithColor(context, yellowColor)
                    }else{
                        CGContextSetFillColorWithColor(context, orangeColor)
                    }
                }else{
                    if(row % 2 != 0){
                        CGContextSetFillColorWithColor(context, orangeColor)
                    }else{
                        CGContextSetFillColorWithColor(context, yellowColor)
                    }
                }
                var aRect = CGRectMake(CGFloat(row) * size, CGFloat(line) * size, size, size)
                CGContextFillRect(context, aRect)
            }
        }
        CGContextFillPath(context)
    }
    
    func handleGesture(sender:UITapGestureRecognizer){
        let point:CGPoint = sender.locationInView(self)
        let line  = point.y/size
        let row = point.x/size
        delegate?.didTouchView(self, line: Int(line), row: Int(row))
    }
    
}
