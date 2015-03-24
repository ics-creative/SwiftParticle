//
//  GameScene.swift
//  SwiTonkotsuParticle
//
//  Created by 鹿野壮 on 2015/03/24.
//  Copyright (c) 2015年 鹿野壮. All rights reserved.
//
import SpriteKit

class GameScene: SKScene {
    /** パーティクル発生装置 */
    var particleEmitter:SKEmitterNode = SKEmitterNode(fileNamed: "MyParticle.sks");
    var smokeParticleEmitter:SKEmitterNode = SKEmitterNode(fileNamed: "MyParticle2.sks");

    /** 発生装置の現在地 */
    var currentPoint:CGPoint = CGPoint(x: 0, y: 0);
    /** 発生装置の目的地 */
    var goalPoint:CGPoint = CGPoint(x: 0, y: 0);
    /** パーティクルの色相。時間とともに変化する */
    var hue:CGFloat = 0;
    var s:CGFloat = 80;
    var v:CGFloat = 2;
    var a:CGFloat = 1;
    
    /** 画面が表示された時に実行される */
    override func didMoveToView(view: SKView) {
        // 背景色の設定
        self.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.1, alpha: 1);
        // パーティクル発生装置を配置
        addChild(particleEmitter);
        addChild(smokeParticleEmitter);
    }
    
    /**
    タッチが開始したときに実行される関数
    */
    override func update(currentTime: CFTimeInterval) -> Void
    {
        let difX:CGFloat = goalPoint.x - currentPoint.x;
        let difY:CGFloat = goalPoint.y - currentPoint.y;
        currentPoint.x += difX * 0.9;
        currentPoint.y += difY * 0.9;
        particleEmitter.particlePosition = currentPoint;
        smokeParticleEmitter.particlePosition = currentPoint;
        
        hue += 0.004;
        if(hue > 1)
        {
            hue = 0;
        }
        
        let color:UIColor = UIColor(hue: hue, saturation: s, brightness: v, alpha:a);
        particleEmitter.particleColor = color;
        smokeParticleEmitter.particleColor = color;
    }
    
    /**
    タッチが開始したときに実行される関数
    */
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        touchHandler(touches);
    }
    
    /**
    タッチが移動したときに実行される関数
    */
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        touchHandler(touches);
    }
    
    /**
    タッチを終えたときに実行される関数
    */
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    /**
    タッチ開始、タッチ移動の時の処理
    */
    func touchHandler(touches: NSSet) -> Void {
        for touch in touches {
            var location = touch.locationInNode(self);
            goalPoint = location;
        }
    }
}
