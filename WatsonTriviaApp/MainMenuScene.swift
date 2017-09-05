/** 
 * Copyright IBM Corporation 2016, 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import SpriteKit

class MainMenuScene: SKScene {

    let backgroundImage = SKSpriteNode(imageNamed: "question_mark")
    let settings = SKSpriteNode(imageNamed: "settings")
    let play = SKSpriteNode(imageNamed: "play_icon")
    var title: SKSpriteNode = SKSpriteNode()
    let highScore = SKLabelNode(fontNamed: fontName)
    var gameVC: GameViewController!

    /**
     Set up all of the images for the main menu
     */
    override func didMove(to view: SKView) {

        title = SKSpriteNode(imageNamed: gameVC.rocket.languageConstants.titleName)

        backgroundColor = UIColor.black

        backgroundImage.size.height = backgroundImage.size.height * size.width / backgroundImage.size.width
        backgroundImage.size.width = size.width
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.zPosition = -20

        title.size.height = title.size.height * size.width / title.size.width
        title.size.width = size.width
        title.position = CGPoint(x: 0 + title.size.width/2, y: size.height - title.size.height/2)
        title.zPosition = -10

        settings.size.height = settings.size.height * size.width / (settings.size.width * 6)
        settings.size.width = size.width / 6
        settings.position = CGPoint(x: size.width - (settings.size.width * 0.6), y: settings.size.width * 0.6)

        play.size.height = play.size.height * size.width / (play.size.width * 6)
        play.size.width = size.width / 6
        play.position = CGPoint(x: play.size.width * 0.6, y: play.size.height * 0.6)

        highScore.text = gameVC.rocket.languageConstants.highS + "\(gameVC.getHighScore())"
        highScore.fontSize = 25
        highScore.fontColor = UIColor(red: 39.0/255.0, green: 196.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        highScore.position = CGPoint(x: size.width / 2, y: highScore.fontSize / 2)
        highScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center

        addChild(backgroundImage)
        addChild(title)
        addChild(settings)
        addChild(play)
        addChild(highScore)
    }

    /**
     The user can hit settings to change the language or anywhere else (play button is optional)
     to continue on to the game
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            switch self.atPoint(location) {
            case self.settings :
                gameVC.transitionToSettings()
            default :
                gameVC.transitionToGame()
            }

        }
    }
}
