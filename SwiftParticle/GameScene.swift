//
//  GameScene.swift
//  SwiTonkotsuParticle
//
//  Created by 鹿野壮 on 2015/03/24.
//  Copyright (c) 2015年 鹿野壮. All rights reserved.
//
import SpriteKit

class GameScene: SKScene {
    /** 1つのパーティクル発生装置から発生するパーティクルの数 */
    var particleNum:CGFloat = 0;
    /** パーティクル発生装置の数 */
    let EMITTER_NUM:Int = 8;
    /** 煙パーティクル発生装置の数 */
    let SMOKE_EMMITER_NUM:Int = 3;
    /** パーティクル発生装置をまとめた配列 */
    var emmiterSet:[SKEmitterNode] = [SKEmitterNode]();
    /** パーティクルの発生位置 */
    var emmitPoint:CGPoint = CGPoint(x: 0, y: 0);
    /** パーティクル発生装置の数 */
    var hue:CGFloat = 0;
    // そのほかのパーティクルの色情報
    var s:CGFloat = 80;
    var v:CGFloat = 2;
    var a:CGFloat = 1;
    /** タッチ中かどうか */
    var isTouch:Bool = false;
    /** タッチ箇所の数 */
    var touchCount:Int = 0;
    
    /** 画面が表示された時に実行される */
    override func didMoveToView(view: SKView) {
        // 背景色の設定
        self.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.1, alpha: 1);
        // 光のパーティクルの発生装置
        var particleEmitter:SKEmitterNode = SKEmitterNode(fileNamed: "MyParticle.sks");
        particleNum = particleEmitter.particleBirthRate;
        // 煙のパーティクルの発生装置
        var smokeEmitter:SKEmitterNode = SKEmitterNode(fileNamed: "MySmoke.sks");
        // 両方のパーティクル発生装置を配列に格納していく。
        for var i:Int = 0; i < EMITTER_NUM; i++ {
            var copiedEmmiter:SKEmitterNode!;
            if(i < EMITTER_NUM - SMOKE_EMMITER_NUM)
            {
                copiedEmmiter = particleEmitter.copy() as! SKEmitterNode;
            }
            else
            {
                copiedEmmiter = smokeEmitter.copy() as! SKEmitterNode;
            }
            emmiterSet.append(copiedEmmiter);
            // 作成したパーティクル発生装置を画面に配置
            addChild(copiedEmmiter);
        }
    }
    
    /**
    画面更新毎に実行される関数。色と発生位置を変更する。
    */
    override func update(currentTime: CFTimeInterval) -> Void
    {
        hue += 0.002;
        if(hue > 1)
        {
            hue = 0;
        }
        
        let color:UIColor = UIColor(hue: hue, saturation: s, brightness: v, alpha:a);
        
        for emitter:SKEmitterNode in emmiterSet {
            emitter.particleColor = color;
            emitter.particlePosition = emmitPoint;
            if(!isTouch && emitter.particleBirthRate > 0)
            {
                emitter.particleBirthRate = 0;
            }
            else if(isTouch && emitter.particleBirthRate == 0)
            {
                emitter.particleBirthRate = particleNum;
            }
            emitter.alpha = CGFloat(arc4random() % 1000) / 1000;
        }
        
    }
    
    /**
    タッチが開始したときに実行される関数
    */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        changeEmmitPointHandler(touches);
        var touchedCount:Int = touches.count;
        touchCount = touchedCount;
        touchesCountChangeHandler();
    }
    
    /**
    タッチが移動したときに実行される関数
    */
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        changeEmmitPointHandler(touches);
    }
    
    /**
    タッチを終えたときに実行される関数
    */
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touchEndCount:Int = touches.count;
        touchCount = touchCount - touchEndCount;
        touchesCountChangeHandler();
    }
    
    /**
    パーティクルの発生位置を変更する関数
    */
    func changeEmmitPointHandler(touches: Set<NSObject>) {
        for touch:NSObject in touches {
            var uiTouch:UITouch = touch as! UITouch;
            var location = uiTouch.locationInNode(self);
            emmitPoint = location;
        }
    }
    
    /**
    タッチ中の指の数が変わった時の処理
    */
    func touchesCountChangeHandler() -> Void {
        isTouch = touchCount > 0;
    }
}
