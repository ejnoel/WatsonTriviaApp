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

class SingleCatGame: SKScene {

    /// Define nodes that will change based on category as 'var'
    var rocket: SKSpriteNode = SKSpriteNode()
    var title: SKSpriteNode = SKSpriteNode()
    var retry: SKSpriteNode = SKSpriteNode()
    var exit: SKSpriteNode = SKSpriteNode()

    /// Define nodes that will remain constant across categories as 'let'
    let backgroundImage = SKSpriteNode(imageNamed: "space")
    let ground = SKSpriteNode(imageNamed: "ground")
    let highScore = SKSpriteNode(imageNamed: "high_score")
    let qLine1 = SKLabelNode(fontNamed: fontName)
    let qLine2 = SKLabelNode(fontNamed: fontName)
    let qLine3 = SKLabelNode(fontNamed: fontName)
    let qLine4 = SKLabelNode(fontNamed: fontName)
    let ans1 = SKLabelNode(fontNamed: fontName)
    let ans2 = SKLabelNode(fontNamed: fontName)
    let ans3 = SKLabelNode(fontNamed: fontName)
    let ans4 = SKLabelNode(fontNamed: fontName)
    let basePt = SKLabelNode(fontNamed: fontName)
    let baseNum = SKLabelNode(fontNamed: fontName)
    let accBonus = SKLabelNode(fontNamed: fontName)
    let accNum = SKLabelNode(fontNamed: fontName)
    let diffBonus = SKLabelNode(fontNamed: fontName)
    let diffNum = SKLabelNode(fontNamed: fontName)
    let totalScore = SKLabelNode(fontNamed: fontName)
    let totalNum = SKLabelNode(fontNamed: fontName)
    let comboNum = SKLabelNode(fontNamed: fontName)

    /// Set up additional variables
    let qFontSize: CGFloat = 18
    let aFontSize: CGFloat = 18
    let scoreFontSize: CGFloat = 20
    let fontCol: UIColor = UIColor.white
    let scoreCol: UIColor = UIColor.black
    let fontCorrectCol: UIColor = UIColor(red: 39.0/255.0, green: 196.0/255.0, blue: 243.0/255.0, alpha: 1.0)
    let fontIncorrectCol: UIColor = UIColor(red: 200.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    var moveToNextQuestion: Bool = true
    var gameVC: GameViewController!
    var serverConnect: ServerConnect!
    var scoreController: ScoreController!
    var questionController: QuestionController!
    var resultWord = "" {
        didSet {
            checkSpeechResult()
        }
    }

    /**
     The didMove function is a default function that needs to be overriden
     in order to set the things that will appear when the scene first loads,
     before any actions are taken by the user
     */
    override func didMove(to view: SKView) {

        let xPosText: CGFloat = size.width / 20

        /// Set up speech if it is enabled
        if gameVC.speechEnabled {
            gameVC.initTextSpeech()
        }

        /// Set up buttons with text based on language
        title = SKSpriteNode(imageNamed: gameVC.rocket.languageConstants.titleName)
        retry = SKSpriteNode(imageNamed: gameVC.rocket.languageConstants.retryName)
        exit = SKSpriteNode(imageNamed: gameVC.rocket.languageConstants.exitName)

        /// Additional variables that must be set up within didMove function
        backgroundColor = UIColor.black
        backgroundImage.size.height = backgroundImage.size.height * size.width / backgroundImage.size.width
        backgroundImage.size.width = size.width
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.zPosition = -20
        backgroundImage.alpha = 0.5

        rocket = SKSpriteNode(imageNamed: gameVC.rocket.rocketParts[0])
        rocket.size.height = rocket.size.height * size.width / ( 2.8 * rocket.size.width )
        rocket.size.width = size.width / 2.8
        rocket.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        rocket.position = CGPoint(x: size.width * 0.8, y: rocket.size.height * 0.3)
        rocket.zPosition = 20
        rocket.alpha = 0

        qLine1.fontSize = qFontSize
        qLine1.fontColor = fontCol
        qLine1.position = CGPoint(x: xPosText, y: size.height * 0.77)
        qLine1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        qLine1.zPosition = 30

        qLine2.fontSize = qFontSize
        qLine2.fontColor = fontCol
        qLine2.position = CGPoint(x: xPosText, y: size.height * 0.73)
        qLine2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        qLine2.zPosition = 30

        qLine3.fontSize = qFontSize
        qLine3.fontColor = fontCol
        qLine3.position = CGPoint(x: xPosText, y: size.height * 0.69)
        qLine3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        qLine3.zPosition = 30

        qLine4.fontSize = qFontSize
        qLine4.fontColor = fontCol
        qLine4.position = CGPoint(x: xPosText, y: size.height * 0.65)
        qLine4.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        qLine4.zPosition = 30

        ans1.fontSize = aFontSize
        ans1.fontColor = fontCol
        ans1.position = CGPoint(x: xPosText, y: size.height * 0.57)
        ans1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        ans1.zPosition = 30

        ans2.fontSize = aFontSize
        ans2.fontColor = fontCol
        ans2.position = CGPoint(x: xPosText, y: size.height * 0.48)
        ans2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        ans2.zPosition = 30

        ans3.fontSize = aFontSize
        ans3.fontColor = fontCol
        ans3.position = CGPoint(x: xPosText, y: size.height * 0.39)
        ans3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        ans3.zPosition = 30

        ans4.fontSize = aFontSize
        ans4.fontColor = fontCol
        ans4.position = CGPoint(x: xPosText, y: size.height * 0.3)
        ans4.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        ans4.zPosition = 30

        basePt.text = gameVC.rocket.languageConstants.baseScore
        basePt.fontSize = scoreFontSize
        basePt.fontColor = scoreCol
        basePt.position = CGPoint(x: -(size.width / 3),
                                  y: 0 )
        basePt.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        basePt.zPosition = 20

        baseNum.fontSize = scoreFontSize
        baseNum.fontColor = scoreCol
        baseNum.position = CGPoint(x: size.width * 0.15,
                                   y: 0 )
        baseNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        baseNum.zPosition = 20
        baseNum.alpha = 0

        accBonus.text = gameVC.rocket.languageConstants.accuracy
        accBonus.fontSize = scoreFontSize
        accBonus.fontColor = scoreCol
        accBonus.position = CGPoint(x: -(size.width / 3),
                                    y: -(ground.size.height * 0.04))
        accBonus.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        accBonus.zPosition = 20

        accNum.fontSize = scoreFontSize
        accNum.fontColor = scoreCol
        accNum.position = CGPoint(x: size.width * 0.15,
                                  y: -(ground.size.height * 0.04))
        accNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        accNum.zPosition = 20
        accNum.alpha = 0

        diffBonus.text = gameVC.rocket.languageConstants.difficulty
        diffBonus.fontSize = scoreFontSize
        diffBonus.fontColor = scoreCol
        diffBonus.position = CGPoint(x: -(size.width / 3),
                                     y: -(ground.size.height * 0.08))
        diffBonus.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        diffBonus.zPosition = 20

        diffNum.fontSize = scoreFontSize
        diffNum.fontColor = scoreCol
        diffNum.position = CGPoint(x: size.width * 0.15,
                                   y: -(ground.size.height * 0.08))
        diffNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        diffNum.zPosition = 20
        diffNum.alpha = 0

        totalScore.text = gameVC.rocket.languageConstants.final
        totalScore.fontSize = scoreFontSize
        totalScore.fontColor = scoreCol
        totalScore.position = CGPoint(x: -(size.width / 3),
                                      y: -(ground.size.height * 0.12))
        totalScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        totalScore.zPosition = 20

        totalNum.fontSize = scoreFontSize
        totalNum.fontColor = scoreCol
        totalNum.position = CGPoint(x: size.width * 0.15,
                                    y: -(ground.size.height * 0.12))
        totalNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        totalNum.zPosition = 20
        totalNum.alpha = 0

        comboNum.fontSize = scoreFontSize
        comboNum.fontColor = scoreCol
        comboNum.position = CGPoint(x: -(size.width / 3),
                                    y: -(ground.size.height * 0.16))
        comboNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        comboNum.zPosition = 20
        comboNum.alpha = 0

        title.size.height = title.size.height * size.width / title.size.width
        title.size.width = size.width
        title.position = CGPoint(x: 0 + title.size.width/2, y: size.height - title.size.height/2)
        title.zPosition = -10

        ground.size.height = ground.size.height * size.width / ground.size.width
        ground.size.width = size.width
        ground.position = CGPoint(x: ground.size.width/2,
                                  y: ground.size.height/2 - (ground.size.height * 2 / 3))
        ground.zPosition = 10

        exit.size.height = exit.size.height * size.width / (2.5 * exit.size.width)
        exit.size.width = size.width / 2.5
        exit.position = CGPoint(x: size.width / 4.7,
                                y: -(ground.size.height/2.55))
        exit.zPosition = 20

        retry.size.height = exit.size.height
        retry.size.width = exit.size.width
        retry.position = CGPoint(x: -(size.width / 4.6),
                                 y: -(ground.size.height/2.55))
        retry.zPosition = 20

        highScore.size.width = highScore.size.width * 60 / highScore.size.height
        highScore.size.height = 60
        highScore.position = CGPoint(x: -exit.size.width,
                                     y: totalNum.position.y + 10)
        highScore.zPosition = 20
        highScore.alpha = 0

        /// Each node must be added to the view
        addChild(backgroundImage)
        addChild(title)
        addChild(ground)
        addChild(rocket)
        ground.addChild(exit)
        ground.addChild(retry)
        ground.addChild(basePt)
        ground.addChild(baseNum)
        ground.addChild(accBonus)
        ground.addChild(accNum)
        ground.addChild(diffBonus)
        ground.addChild(diffNum)
        ground.addChild(totalScore)
        ground.addChild(totalNum)
        ground.addChild(comboNum)
        ground.addChild(highScore)
        addChild(qLine1)
        addChild(qLine2)
        addChild(qLine3)
        addChild(qLine4)
        addChild(ans1)
        addChild(ans2)
        addChild(ans3)
        addChild(ans4)
    }

    /**
     This function handles when a user touches the screen.
     
     The user will select answers for each question. Actions will vary based on if the answer is
     correct or incorrect. Once the user has completed the round, the score will appear. The user
     then has options to either retry the same category, or exit to the main menu.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            var selectedAns: String = ""
            var selectedNum: Int = 0
            /// Check that we haven't already answered all the questions. This avoids issues with
            /// the user touching the labels after the final correct answer is given.
            if scoreController.correctAnswers < maxCorrect
                && moveToNextQuestion
                && gameVC.currentQuestion.correct.characters.count > 0 {
                if self.atPoint(location) == self.ans1 {
                    moveToNextQuestion = false
                    selectedAns = gameVC.currentQuestion.ansArray[0]
                    selectedNum = 1
                } else if self.atPoint(location) == self.ans2 {
                    moveToNextQuestion = false
                    selectedAns = gameVC.currentQuestion.ansArray[1]
                    selectedNum = 2
                } else if self.atPoint(location) == self.ans3 {
                    moveToNextQuestion = false
                    selectedAns = gameVC.currentQuestion.ansArray[2]
                    selectedNum = 3
                } else if self.atPoint(location) == self.ans4 {
                    moveToNextQuestion = false
                    selectedAns = gameVC.currentQuestion.ansArray[3]
                    selectedNum = 4
                }

                if  selectedAns == gameVC.currentQuestion.correct {
                    questionAnsweredCorrectly()
                } else if selectedAns.characters.count > 0 {
                    questionAnsweredIncorrectly(numSelected: selectedNum)
                }
            }
            /// If the user selects retry, we reset the indices and the nodes to their starting positions
            if self.atPoint(location) == self.retry {
                retryGame()
            }

            /// If the user selects exit, we return to the Main Menu
            if self.atPoint(location) == self.exit {
                gameVC.reloadMainMenu()
            }
        }
    }

    func retryGame() {
        self.moveToNextQuestion = true
        if questionController.questionQueue.count > 0 {
            gameVC.currentQuestion = questionController.questionQueue[0]
            questionController.questionQueue.remove(at: 0)
        } else {
            gameVC.currentQuestion = Question()
        }
        /// Reset rocket to original position and image
        rocket.position.y -= size.height
        rocket.texture = SKTexture(imageNamed: gameVC.rocket.rocketParts[0])

        /// Make rocket and score values disappear
        rocket.alpha = 0
        highScore.alpha = 0
        baseNum.alpha = 0
        accNum.alpha = 0
        diffNum.alpha = 0
        comboNum.alpha = 0
        totalNum.alpha = 0

        /// Make the questions and answers reappear
        qLine1.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeIn(withDuration: 1)]))
        qLine2.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeIn(withDuration: 1)]))
        qLine3.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeIn(withDuration: 1)]))
        qLine4.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeIn(withDuration: 1)]))
        ans1.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeIn(withDuration: 1)]))
        ans2.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeIn(withDuration: 1)]))
        ans3.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeIn(withDuration: 1)]))
        ans4.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeIn(withDuration: 1)]))

        /// Move the ground and reset the text
        let moveGroundDown = SKAction.moveBy(x: 0, y: -(ground.size.height * 2 / 3), duration: 1)
        ground.run(moveGroundDown)
        setQAText()
        resetAllTextWhite()
        scoreController.resetScores()
    }

    /**
     Set the correct answer to green
     */
    func correctAnsGreen() {
        if gameVC.currentQuestion.correct == gameVC.currentQuestion.ansArray[0] {
            self.ans1.fontColor = fontCorrectCol
        } else if gameVC.currentQuestion.correct == gameVC.currentQuestion.ansArray[1] {
            self.ans2.fontColor  = fontCorrectCol
        } else if gameVC.currentQuestion.correct == gameVC.currentQuestion.ansArray[2] {
            self.ans3.fontColor  = fontCorrectCol
        } else {
            self.ans4.fontColor  = fontCorrectCol
        }
    }

    /**
     Set the user selected incorrect answer to red
     */
    func incorrectRed(answerSelected: Int) {
        switch answerSelected {
        case 1 :
            self.ans1.fontColor  = fontIncorrectCol
        case 2 :
            self.ans2.fontColor  = fontIncorrectCol
        case 3 :
            self.ans3.fontColor  = fontIncorrectCol
        default :
            self.ans4.fontColor  = fontIncorrectCol
        }
    }

    /**
     Set all answers back to white
     */
    func resetAllTextWhite() {
        self.ans1.fontColor  = UIColor.white
        self.ans2.fontColor  = UIColor.white
        self.ans3.fontColor  = UIColor.white
        self.ans4.fontColor  = UIColor.white
    }

    /**
     Set the questions and answers in their text fields.
     */
    func setQAText() {
        let multiQuestion = questionController.parseMultiline(inString : gameVC.currentQuestion.question)
        if multiQuestion.count == 4 {
            qLine1.text = multiQuestion[0]
            qLine2.text = multiQuestion[1]
            qLine3.text = multiQuestion[2]
            qLine4.text = multiQuestion[3]
            ans1.text = "1. " + gameVC.currentQuestion.ansArray[0]
            ans2.text = "2. " + gameVC.currentQuestion.ansArray[1]
            ans3.text = "3. " + gameVC.currentQuestion.ansArray[2]
            ans4.text = "4. " + gameVC.currentQuestion.ansArray[3]
        }
    }

    /**
     Respond if the user answers the question correctly via touch or voice
     */
    func questionAnsweredCorrectly() {
        gameVC.currentQuestion.answered = true
        if gameVC.speechEnabled {
            gameVC.stopListening()
        }
        serverConnect.postQuestionResult(answerData: ["question": gameVC.currentQuestion.qID, "correct": true])
        scoreController.questionsAsked += 1
        correctAnsGreen()
        scoreController.scoreIncrement(question: gameVC.currentQuestion)

        /// If this is the final question, show results
        if scoreController.correctAnswers == maxCorrect {
            finalQuestionAnswered()
        /// If this is not the final question, get the next question and add to the rocket
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                if self.scoreController.correctAnswers == 1 {
                    self.rocket.alpha = 1
                } else {
                    self.rocket.texture = SKTexture(imageNamed:
                        self.gameVC.rocket.rocketParts[self.scoreController.correctAnswers-1])
                }
                if self.questionController.questionQueue.count > 0 {
                    self.gameVC.currentQuestion = self.questionController.questionQueue[0]
                    self.questionController.questionQueue.remove(at: 0)
                } else {
                    self.gameVC.currentQuestion = Question()
                }
                self.resetAllTextWhite()
                self.moveToNextQuestion = true
            }
        }
    }

    func finalQuestionAnswered() {
        /// Make the rocket "blast off"
        rocket.texture = SKTexture(imageNamed: gameVC.rocket.rocketParts[scoreController.correctAnswers-1])
        let blastoff = SKAction.moveBy(x: 0, y: size.height, duration: 1)
        rocket.run(SKAction.sequence([SKAction.wait(forDuration: 1), blastoff]))

        /// Calculate the score and set the text fields to show the final score
        scoreController.calculateScore()
        baseNum.text = "\(scoreController.baseScore)"
        accNum.text = "\(scoreController.accuracyBonus)"
        diffNum.text = "\(scoreController.difficultyBonus)"
        totalNum.text = "\(scoreController.finalScore)"
        comboNum.text = "+ \(scoreController.comboBonus)" + gameVC.rocket.languageConstants.bonus

        /// Make the questions and answers disappear
        qLine1.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)]))
        qLine2.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)]))
        qLine3.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)]))
        qLine4.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)]))
        ans1.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)]))
        ans2.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)]))
        ans3.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)]))
        ans4.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)]))

        /// Move the ground up then make text fields appear
        let moveGroundUp = SKAction.moveBy(x: 0, y: ground.size.height * 2 / 3, duration: 1)
        ground.run(SKAction.sequence([SKAction.wait(forDuration: 3),
                                      moveGroundUp]))
        baseNum.run(SKAction.sequence([SKAction.wait(forDuration: 4),
                                       SKAction.fadeIn(withDuration: 1)]))
        accNum.run(SKAction.sequence([SKAction.wait(forDuration: 5),
                                      SKAction.fadeIn(withDuration: 1)]))
        diffNum.run(SKAction.sequence([SKAction.wait(forDuration: 6),
                                       SKAction.fadeIn(withDuration: 1)]))
        totalNum.run(SKAction.sequence([SKAction.wait(forDuration: 7),
                                        SKAction.fadeIn(withDuration: 1)]))
        comboNum.run(SKAction.sequence([SKAction.wait(forDuration: 8),
                                        SKAction.fadeIn(withDuration: 1),
                                        SKAction.wait(forDuration: 1),
                                        SKAction.fadeOut(withDuration: 1)]))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            self.totalNum.text = "\(self.scoreController.addComboBonus())"
            self.totalNum.fontSize = self.scoreFontSize + 2
            if self.checkSetNewHighScore() {
                self.highScore.run(SKAction.sequence([SKAction.wait(forDuration: 1),
                                                      SKAction.fadeIn(withDuration: 0)]))
            }
        }
    }

    /**
     Respond if the user answers incorrectly, whether via touch or voice
     */
    func questionAnsweredIncorrectly(numSelected: Int) {
        gameVC.currentQuestion.answered = true
        if gameVC.speechEnabled {
            gameVC.stopListening()
        }
        scoreController.comboCount = 0
        serverConnect.postQuestionResult(answerData: ["question": gameVC.currentQuestion.qID, "correct": false])
        correctAnsGreen()
        incorrectRed(answerSelected: numSelected)
        scoreController.questionsAsked += 1

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.resetAllTextWhite()
            if self.questionController.questionQueue.count > 0 {
                self.gameVC.currentQuestion = self.questionController.questionQueue[0]
                self.questionController.questionQueue.remove(at: 0)
            } else {
                self.gameVC.currentQuestion = Question()
            }

            self.moveToNextQuestion = true
        }
    }

    /**
     When the resultWord variable is changed, we will call this function
     to check if the result is correct or incorrect, and move forward
     to the next question
     */
    func checkSpeechResult() {
        if resultWord == gameVC.currentQuestion.correct {
            questionAnsweredCorrectly()
        } else if resultWord == gameVC.currentQuestion.ansArray[0] {
            questionAnsweredIncorrectly(numSelected: 1)
        } else if resultWord == gameVC.currentQuestion.ansArray[1] {
            questionAnsweredIncorrectly(numSelected: 2)
        } else if resultWord == gameVC.currentQuestion.ansArray[2] {
            questionAnsweredIncorrectly(numSelected: 3)
        } else if resultWord == gameVC.currentQuestion.ansArray[3] {
            questionAnsweredIncorrectly(numSelected: 4)
        }
    }

    func checkSetNewHighScore() -> Bool {
        if gameVC.getHighScore() < scoreController.finalScore {
            gameVC.setHighScore()
            return true
        }
        return false
    }
}
