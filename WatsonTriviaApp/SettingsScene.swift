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

/**
 This scene allows users to select language and sound options. There are several 
 icons for each country and language option available to the user, as well as a 
 sound icon for turning speech-to-text and text-to-speech on and off
 */
class SettingsScene: SKScene {

    let backgroundImage = SKSpriteNode(imageNamed: "space")
    let settings = SKSpriteNode(imageNamed: "settings")
    let sound = SKSpriteNode(imageNamed: "sound")
    let soundOff = SKSpriteNode(imageNamed: "soundoff")
    let usYes = SKSpriteNode(imageNamed: "rocket_michael_yes")
    let usNo = SKSpriteNode(imageNamed: "rocket_michael_no")
    let gbNo = SKSpriteNode(imageNamed: "rocket_kate_no")
    let gbYes = SKSpriteNode(imageNamed: "rocket_kate_yes")
    let mxNo = SKSpriteNode(imageNamed: "rocket_sofia_no")
    let mxYes = SKSpriteNode(imageNamed: "rocket_sofia_yes")
    let esNo = SKSpriteNode(imageNamed: "rocket_enrique_no")
    let esYes = SKSpriteNode(imageNamed: "rocket_enrique_yes")
    var gameVC: GameViewController!
    var selectedLangAccent: String!

    /**
     Set up all of the images for the main menu
     */
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        backgroundImage.size.height = backgroundImage.size.height * size.width / backgroundImage.size.width
        backgroundImage.size.width = size.width
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.zPosition = -20
        backgroundImage.alpha = 0.5

        settings.size.height = settings.size.height * size.width / (settings.size.width * 6)
        settings.size.width = size.width / 6
        settings.position = CGPoint(x: size.width - (settings.size.width * 0.6), y: settings.size.width * 0.6)
        settings.zPosition = 10

        sound.size.height = sound.size.height * size.width / (sound.size.width * 6)
        sound.size.width = size.width / 6
        sound.position = CGPoint(x: sound.size.width * 0.6, y: sound.size.height * 0.6)
        sound.zPosition = 10

        soundOff.size.height = soundOff.size.height * size.width / (soundOff.size.width * 6)
        soundOff.size.width = size.width / 6
        soundOff.position = CGPoint(x: soundOff.size.width * 0.6, y: soundOff.size.height * 0.6)
        soundOff.zPosition = 10

        usYes.size.height = usYes.size.height * size.width / (usYes.size.width * 2.2)
        usYes.size.width = size.width / 2.2
        usYes.position = CGPoint(x: usYes.size.width * 0.5, y: size.height - (usYes.size.height * 0.5))

        usNo.size.height = usYes.size.height
        usNo.size.width = usYes.size.width
        usNo.position = usYes.position

        gbNo.size.height = usYes.size.height
        gbNo.size.width = usYes.size.width
        gbNo.position = CGPoint(x: gbNo.size.width * 0.5, y: size.height - (gbNo.size.height * 1.5))

        gbYes.size.height = usYes.size.height
        gbYes.size.width = usYes.size.width
        gbYes.position = gbNo.position

        mxNo.size.height = usYes.size.height
        mxNo.size.width = usYes.size.width
        mxNo.position = CGPoint(x: size.width - (mxNo.size.width * 0.5), y: size.height - (mxNo.size.height * 0.5))

        mxYes.size.height = usYes.size.height
        mxYes.size.width = usYes.size.width
        mxYes.position = CGPoint(x: size.width - (mxNo.size.width * 0.5), y: size.height - (mxNo.size.height * 0.5))

        esNo.size.height = usYes.size.height
        esNo.size.width = usYes.size.width
        esNo.position = CGPoint(x: size.width - (esNo.size.width * 0.5), y: size.height - (esNo.size.height * 1.5))

        esYes.size.height = usYes.size.height
        esYes.size.width = usYes.size.width
        esYes.position = esNo.position

        addChild(settings)
        addChild(backgroundImage)
        /// Add the images based on which option is currently selected
        selectedLangAccent = gameVC.rocket.languageString
        if selectedLangAccent == "us" {
            addChild(usYes)
        } else {
            addChild(usNo)
        }
        if selectedLangAccent == "mx" {
            addChild(mxYes)
        } else {
            addChild(mxNo)
        }
        if selectedLangAccent == "gb" {
            addChild(gbYes)
        } else {
            addChild(gbNo)
        }
        if selectedLangAccent == "es" {
            addChild(esYes)
        } else {
            addChild(esNo)
        }
        if gameVC.speechEnabled {
            addChild(sound)
        } else {
            addChild(soundOff)
        }
    }

    /**
     Toggle language/country options as well as sound options.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            switch self.atPoint(location) {
            case self.settings :
                gameVC.settingsToMain()
            case self.sound :
                gameVC.toggleSound()
                setSoundIcon()
            case self.soundOff :
                gameVC.toggleSound()
                setSoundIcon()
            case self.usNo :
                setDesiredLanguage(desiredLanguage: "us")
                gameVC.rocket.setUSARocket()
                gameVC.setLanguageDefault()
            case self.gbNo :
                setDesiredLanguage(desiredLanguage: "gb")
                gameVC.rocket.setGBRocket()
                gameVC.setLanguageDefault()
            case self.mxNo :
                setDesiredLanguage(desiredLanguage: "mx")
                gameVC.rocket.setMexRocket()
                gameVC.setLanguageDefault()
            case self.esNo :
                setDesiredLanguage(desiredLanguage: "es")
                gameVC.rocket.setSpainRocket()
                gameVC.setLanguageDefault()
            default : ()
            }
        }
    }

    /**
     Set the sound icon to on or off and change the current setting for sound
     */
    func setSoundIcon() {
        if gameVC.speechEnabled {
            soundOff.removeFromParent()
            addChild(sound)
            gameVC.setSoundDefault(soundOnOrOff: "on")
        } else {
            sound.removeFromParent()
            addChild(soundOff)
            gameVC.setSoundDefault(soundOnOrOff: "off")
        }
    }

    /**
     If a new language/country has been selected, change the icons and default options. If the selection
     is already the default, do nothing
     */
    func setDesiredLanguage(desiredLanguage: String) {
        if selectedLangAccent != desiredLanguage {
            if selectedLangAccent == "us" {
                usYes.removeFromParent()
                addChild(usNo)
            } else if selectedLangAccent == "mx" {
                mxYes.removeFromParent()
                addChild(mxNo)
            } else if selectedLangAccent == "gb" {
                gbYes.removeFromParent()
                addChild(gbNo)
            } else if selectedLangAccent == "es" {
                esYes.removeFromParent()
                addChild(esNo)
            }

            if desiredLanguage == "us" {
                usNo.removeFromParent()
                addChild(usYes)
                selectedLangAccent = "us"
            } else if desiredLanguage == "gb" {
                gbNo.removeFromParent()
                addChild(gbYes)
                selectedLangAccent = "gb"
            } else if desiredLanguage == "mx" {
                mxNo.removeFromParent()
                addChild(mxYes)
                selectedLangAccent = "mx"
            } else if desiredLanguage == "es" {
                esNo.removeFromParent()
                addChild(esYes)
                selectedLangAccent = "es"
            }
        }
    }
}
