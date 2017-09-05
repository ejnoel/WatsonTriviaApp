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

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import TextToSpeechV1
import SpeechToTextV1

class GameViewController: UIViewController, AVAudioPlayerDelegate {

    let transition = SKTransition.fade(withDuration: 0.5)
    var mainScene: MainMenuScene!
    var gameScene: SingleCatGame!
    var settingsScene: SettingsScene!
    var textToSpeech: TextToSpeech!
    var speechToText: SpeechToText!
    var player: AVAudioPlayer?
    var serverConnect: ServerConnect!
    var questionController: QuestionController!
    var scoreController: ScoreController!
    var skView: SKView!
    var rocket: InternationalRocket!
    var speechEnabled: Bool = false
    let defaults = UserDefaults.standard
    var sessionID: String = ""

    /**
     When the currentQuestion is set or reset, we want to either set the text in the scene and get a new question,
     or make a new server request
     */
    var currentQuestion: Question! = Question() {
        didSet {
            if currentQuestion.question.characters.count > 0 {
                gameScene.setQAText()
                serverConnect.getQuestionServerRequest()
                /// If speech is enabled, read question and answers for next question
                if speechEnabled {
                    speakText(question: currentQuestion)
                }
            } else {
                if questionController.questionQueue.count > 0 {
                    currentQuestion = questionController.questionQueue[0]
                    questionController.questionQueue.remove(at: 0)
                    serverConnect.getQuestionServerRequest()
                } else {
                    serverConnect.getQuestionsServerRequest()
                }
            }
        }
    }

    /**
     This string is set when speech to text is enabled. The input from the microphone is translated
     into a string. When this string is updated, we check for any correct or incorrect answers
     */
    var resultsString = "" {
        didSet {
            if !currentQuestion.answered {
                parseResultsString(question: currentQuestion)
            }
        }
    }
    /**
     If an alert is shown, this value will be set depending on the user's selection. We will either
     attempt to get more questions, or we will quit to the main menu
     */
    var returnAction = "" {
        didSet {
            if returnAction == "Try again" {
                currentQuestion = Question()
            } else  if returnAction == "Quit" {
                self.reloadMainMenu()
            }
        }
    }

    /**
     Load initial menu scene upon first starting execution
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        skView = view as? SKView
        skView.isMultipleTouchEnabled = false
        mainScene = MainMenuScene(size: skView.bounds.size)
        mainScene.scaleMode = .resizeFill
        mainScene.gameVC = self
        self.serverConnect = ServerConnect()
        self.questionController = QuestionController()
        self.scoreController = ScoreController()
        self.serverConnect.gameVC = self
        self.questionController.gameVC = self
        serverConnect.questionController = self.questionController
        rocket = InternationalRocket(languageAccent: getDefaultLanguage())
        speechEnabled = getDefaultSound() == "on" ? true : false
        skView.presentScene(mainScene)
    }

    /**
     Transitions into the game scene
     */
    func transitionToGame() {
        questionController.questionQueue.removeAll()
        currentQuestion = Question()
        gameScene = SingleCatGame(size: skView.bounds.size)
        gameScene.questionController = self.questionController
        gameScene.serverConnect = self.serverConnect
        gameScene.scoreController = self.scoreController
        gameScene.scaleMode = .resizeFill
        gameScene.gameVC = self
        skView.presentScene(gameScene, transition: transition)
    }

    /**
     Transition to settings scene
     */
    func transitionToSettings() {
        settingsScene = SettingsScene(size: skView.bounds.size)
        settingsScene.scaleMode = .resizeFill
        settingsScene.gameVC = self
        skView.presentScene(settingsScene, transition: transition)
    }

    /**
     Transition back to main menu from the settings scene
     */
    func settingsToMain() {
        mainScene = MainMenuScene(size: self.view.bounds.size)
        mainScene.scaleMode = .resizeFill
        mainScene.gameVC = self
        skView.presentScene(mainScene, transition: transition)
    }

    /**
     Reload the main menu
     */
    func reloadMainMenu() {
        scoreController.resetScores()
        mainScene = MainMenuScene(size: self.view.bounds.size)
        mainScene.scaleMode = .resizeFill
        mainScene.gameVC = self
        skView.presentScene(mainScene, transition: transition)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    /**
     This function sets up the credentials for the Watson APIs as well
     as the voices and broadband language for speaking and listening
     */
    func initTextSpeech() {
        textToSpeech = TextToSpeech(
            username: Credentials.TextToSpeechUsername,
            password: Credentials.TextToSpeechPassword
        )
        speechToText = SpeechToText(
            username: Credentials.SpeechToTextUsername,
            password: Credentials.SpeechToTextPassword
        )
    }

    /**
     This function handles the call to the Watson text to Speech
     APIs which synthesizes the text into a voice.
     */
    func speakText(question: Question) {
        let failure = { (error: Error) in print(error) }
        textToSpeech.synthesize(
            questionController.concatQuestionAnswerText(question: question),
            voice: rocket.rocketVoice,
            audioFormat: .wav,
            failure: failure) { data in
            do {
                self.player = try AVAudioPlayer(data: data)
                self.player?.delegate = self
                self.player!.play()
            } catch {
                print("Failed to create audio player.")
            }
        }
    }

    /**
     This function will listen to the input from the microphone
     */
    func listenToSpeech() {
        var settings = RecognitionSettings(contentType: .opus)
        settings.continuous = true
        settings.interimResults = true

        let failure = { (error: Error) in print(error) }
        
        speechToText.recognizeMicrophone(settings: settings,
                                         model: rocket.rocketBroadband,
                                         failure: failure) { results in
            self.resultsString = results.bestTranscript
        }
    }

    /**
     When we have results from the Watson Speech to Text API,
     we will parse the results to see if we the user has submitted one of the
     four options, or something that sounds like one of the 4 options in both
     english and spanish
     */
    func parseResultsString(question: Question) {
        let splitResults = resultsString.components(separatedBy: " ")
        for word in splitResults {
            if rocket.language == "en" {
                checkSpeechEnglish(word: word, question: question)
            } else if rocket.language == "es" {
                checkSpeechSpanish(word: word, question: question)
            }
        }
    }

    /**
     Check speech results against english words for possible answers
     */
    func checkSpeechEnglish(word: String, question: Question) {
        if word == "1" || word == "won" || word == "one" {
            gameScene.resultWord = question.ansArray[0]
            question.answered = true
            return
        } else if word == "2" || word == "two" || word == "to" || word == "too" {
            gameScene.resultWord = question.ansArray[1]
            question.answered = true
            return
        } else if word == "3" || word == "three" {
            gameScene.resultWord = question.ansArray[2]
            question.answered = true
            return
        } else if word == "4" || word == "four" || word == "for" || word == "fore" {
            gameScene.resultWord = question.ansArray[3]
            question.answered = true
            return
        }
    }

    /**
     Check speech results against spanish words for possible answers
     */
    func checkSpeechSpanish(word: String, question: Question) {
        if word == "1" || word == "uno" || word == "una" {
            gameScene.resultWord = question.ansArray[0]
            question.answered = true
            return
        } else if word == "2" || word == "dos" {
            gameScene.resultWord = question.ansArray[1]
            question.answered = true
            return
        } else if word == "3" || word == "tres" {
            gameScene.resultWord = question.ansArray[2]
            question.answered = true
            return
        } else if word == "4" || word == "cuatro" {
            gameScene.resultWord = question.ansArray[3]
            question.answered = true
            return
        }
    }

    /**
     This function will start listening when the audio has finished
     */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        listenToSpeech()
    }

    /**
     Stop listening once we have gotten an answer
     */
    func stopListening() {
        if speechToText != nil {
            speechToText.stopRecognizeMicrophone()
        }
    }

    /**
     Error for issues with connecting to the server
     */
    func alertActionServer() {
        let alertController = UIAlertController(title: "Error",
                                                message: rocket.languageConstants.serverString,
                                                preferredStyle: UIAlertControllerStyle.alert)
        let quitAction = UIAlertAction(title: rocket.languageConstants.quit,
                                       style: UIAlertActionStyle.cancel) { (_: UIAlertAction) -> Void in
            self.returnAction = "Quit"
        }
        let tryAgainAction = UIAlertAction(title: rocket.languageConstants.tryAgain,
                                           style: UIAlertActionStyle.default) { (_: UIAlertAction) -> Void in
            self.returnAction = "Try again"
        }
        alertController.addAction(quitAction)
        alertController.addAction(tryAgainAction)
        self.present(alertController, animated: true, completion: nil)
    }

    /**
     Toggle sound on or off
     */
    func toggleSound() {
        speechEnabled = !speechEnabled
    }

    /**
     Sets the high score value in the local defaults
     */
    func setHighScore() {
        defaults.set("\(scoreController.finalScore)", forKey: "highscore")
    }

    /**
     Gets the high score value from the local defaults.
     */
    func getHighScore() -> Int {
        if let score = defaults.string(forKey: "highscore") {
            if let intScore = Int(score) {
                return intScore
            }
        }
        return 0
    }

    /**
     Set the language value in the local defaults.
     */
    func setLanguageDefault() {
        defaults.set(rocket.languageString, forKey: "language")
    }

    /**
     Gets the language value from the local defaults.
     */
    func getDefaultLanguage() -> String {
        if let language = defaults.string(forKey: "language") {
            return language
        }
        return "us"
    }

    /**
     Set the sound value in the local defaults.
     */
    func setSoundDefault(soundOnOrOff: String) {
        defaults.set(soundOnOrOff, forKey: "sound")
    }

    /**
     Get the sound value in the local defaults.
     */
    func getDefaultSound() -> String {
        if let sound = defaults.string(forKey: "sound") {
            return sound
        }
        return "off"
    }

    /**
     Get the language to pass to the HTTP Get URL
     */
    func getServerLanguage() -> String {
        if rocket.language != "en" {
            return rocket.language.uppercased()
        }
        return ""
    }
}
