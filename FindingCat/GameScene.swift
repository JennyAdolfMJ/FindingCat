//
//  GameScene.swift
//  FindingCat
//
//  Created by Jenny on 2025/2/15.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var rootNode : SKNode?
    private var bgNode : SKSpriteNode?
    private var cat : SKSpriteNode?
    
    private var startPnt : CGPoint?
    
    override func didMove(to view: SKView) {
        
        self.rootNode = self.childNode(withName: "//root")
        self.bgNode = self.childNode(withName: "//bg") as? SKSpriteNode
        
        self.cat = self.childNode(withName: "//cat") as? SKSpriteNode
        self.cat?.isHidden = true;
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler(_:)));
        view.addGestureRecognizer(pinch);
        
    }
    
    @objc func pinchHandler(_ gesture: UIPinchGestureRecognizer)
    {
        switch gesture.state {
        case .began, .changed:

            // 更新 SKSpriteNode 的缩放比例
            let newScale = rootNode!.xScale * gesture.scale
            
            let maxX = (self.bgNode!.size.width * newScale - size.width)/2
            let maxY = (self.bgNode!.size.height * newScale - size.height)/2
            
            if (newScale > 1 && newScale < 1.5 &&
                abs(self.rootNode!.position.x) < maxX &&
                abs(self.rootNode!.position.y) < maxY)
            {
                rootNode!.setScale(newScale)
            }

            // 重置手势的缩放比例，以便下一次变化是相对于当前状态的
            gesture.scale = 1.0
        default:
            break
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        startPnt = pos;
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        let offsetX = pos.x - startPnt!.x;
        let offsetY = pos.y - startPnt!.y;
        
        let maxX = (self.bgNode!.size.width*rootNode!.xScale - size.width)/2
        let maxY = (self.bgNode!.size.height*rootNode!.xScale - size.height)/2
        
        if (offsetX > 0)
        {
            self.rootNode!.position.x = min(maxX, self.rootNode!.position.x+offsetX)
        }
        else
        {
            self.rootNode!.position.x = max(-maxX, self.rootNode!.position.x+offsetX)
        }
        
        if (offsetY > 0)
        {
            self.rootNode!.position.y = min(maxY, self.rootNode!.position.y+offsetY)
        }
        else
        {
            self.rootNode!.position.y = max(-maxY, self.rootNode!.position.y+offsetY)
        }
        
        startPnt = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        let point = CGPoint(x: (pos.x-rootNode!.position.x) / rootNode!.xScale ,
                            y: (pos.y-rootNode!.position.y) / rootNode!.xScale)
        
        if (cat!.contains(point))
        {
            cat?.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
