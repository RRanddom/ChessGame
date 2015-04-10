//
//  ViewController.swift
//  ChessGame
//
//  Created by apple on 15-4-10.
//  Copyright (c) 2015年 apple.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ChessViewDelegate {
    
    var horse_count = 0
    
    var line = 0
    var row = 0
    var size:CGFloat = 0.0
    var score = 0
    
    var state = Array< Array<Bool> >()
    var nextStep = Array<Int>()
    
    var horse = UIImageView(image: UIImage(named: "darkhorse"))
    var horses = Array< UIImageView>()
    
    @IBOutlet weak var chessView: ChessView!
    @IBOutlet weak var scoreLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        size = chessView.frame.size.height/CGFloat(6)
        chessView.delegate = self
        
        initData()
        gameStart()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initData(){
        horse_count = 0
        state.removeAll(keepCapacity: false)
        
        for i in 1...6{
            state.append(Array(count:6,repeatedValue:false))
        }
        
        scoreLabel.text = "Score :0"
    }
    
    func gameStart(){
        
        let tmp = Int(arc4random() % 36)
        
        line = tmp / 6
        row = tmp % 6
        
        state[line][row] = true
        
        drawDarkHorse(line, row: row)
        
        getNextStep()
        
        for i in nextStep {
            drawClearHorse(i>>4, row: i&0xf)
        }
        
    }
    
    @IBAction func gameRestart(){
        for views in chessView.subviews{
            views.removeFromSuperview()
        }
        initData()
        gameStart()
    }
    
    
    func drawDarkHorse(line:Int,row:Int){
        
        horse.removeFromSuperview()
       
        horse.frame = CGRectMake(size*(CGFloat(row)+0.25), size*(CGFloat(line)+0.1), 0.5*size, 0.8*size)
        
        chessView.addSubview(horse)
    }
    
    func drawClearHorse(line:Int,row:Int){
        var clearHorseView = UIImageView(frame: CGRectMake((CGFloat(row)+0.25)*size,size*(CGFloat(line)+0.1) , 0.5*size, 0.8*size))
        clearHorseView.image = UIImage(named: "clearhorse")
        chessView.addSubview(clearHorseView)
        horses.append(clearHorseView)
    }
    
    func removeAllClearHorse(){
        for ahorse in horses{
            ahorse.removeFromSuperview()
        }
        horses.removeAll(keepCapacity: false)
    }
    
    func drawNumber(line:Int,row:Int,number:Int){
        var numberImage = UIImageView(frame: CGRectMake(CGFloat(row)*size, CGFloat(line)*size, size, size))
        numberImage.backgroundColor = UIColor(red: 0.389, green: 0.256, blue: 0.226, alpha: 1.0)
        var label = UILabel(frame: CGRectMake(0, 0, size, size))
        label.font = UIFont(name: "Menlo-Regular", size: 23)
        label.text = String(format: "%d",  number)
        label.textAlignment = NSTextAlignment.Center
        numberImage.addSubview(label)
        chessView.addSubview(numberImage)
    }
    
    func getNextStep() {
        
        nextStep.removeAll(keepCapacity: false)
        //
        removeAllClearHorse()
        
        if(line+2<6 && row+1<6 && !state[line+2][row+1]){
            nextStep.append((line+2)<<4+row+1)
            drawClearHorse(line+2, row: row+1)
        }
        
        if(line+2<6 && row-1>=0 && !state[line+2][row-1]){
            nextStep.append((line+2)<<4+row-1)
            drawClearHorse(line+2, row: row-1)
        }
        
        if(line+1<6 && row+2<6 && !state[line+1][row+2]){
            nextStep.append((line+1)<<4+row+2)
             drawClearHorse(line+1, row: row+2)
        }
        
        if(line+1<6 && row-2>=0 && !state[line+1][row-2]){
            nextStep.append((line+1)<<4+row-2)
            drawClearHorse(line+1, row: row-2)
        }
        
        if(line-1>=0 && row+2<6 && !state[line-1][row+2]){
            nextStep.append((line-1)<<4+row+2)
            drawClearHorse(line-1, row: row+2)
        }
        
        if(line-1>=0 && row-2>=0 && !state[line-1][row-2]){
            nextStep.append((line-1)<<4+row-2)
            drawClearHorse(line-1, row: row-2)
        }
        
        if(line-2>=0 && row+1<6 && !state[line-2][row+1]){
            nextStep.append((line-2)<<4+row+1)
            drawClearHorse(line-2, row: row+1)
        }
        
        if(line-2>=0 && row-1>=0 && !state[line-2][row-1]){
            nextStep.append((line-2)<<4+row-1)
            drawClearHorse(line-2, row: row-1)
        }
        
    }
    
    func shakeAnimation()
    {
        var animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0,3,-3,3,-3,3,0]
        animation.keyTimes = [0,0.1,0.2,0.3,0.4,0.5]
        animation.duration = 0.2
        
        animation.additive = true
        horse.layer.addAnimation(animation, forKey: "shake")
    }
    

    func didTouchView(view: UIView, line: Int, row: Int) {
        let touchPoint = line<<4+row
        for point in nextStep{
            if( point == touchPoint){
                drawNumber(self.line, row: self.row, number: ++horse_count)
                
                self.line = point >> 4
                self.row = point&0xf
                score++
                
                scoreLabel.text = String(format: "Score :%d", score*10)
                state[line][row] = true
                
                drawDarkHorse(line, row: row)
                getNextStep()
                return
            }
        }
        
        shakeAnimation()
        
        if(nextStep.count == 0){
            //game over animation
            
            return
        }
    }
}

