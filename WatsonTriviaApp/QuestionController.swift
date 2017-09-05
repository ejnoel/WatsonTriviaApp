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

class QuestionController {

    var line1: String = ""
    var line2: String = ""
    var line3: String = ""
    var line4: String = ""
    var questionQueue = [Question()]
    var gameVC: GameViewController!

    init() {
    }

    /**
     Separates questions out into up to 4 strings, which can be used to create
     a multi line SKLabelNode for question display
     
     Returns an empty array if the question doesn't fit
     */
    func parseMultiline(inString: String) -> [String] {
        let maxQuestionSize: Int = 140
        let maxLineLength: Int = 40
        var multiQuestion = [line1, line2, line3, line4]

        if inString.characters.count > maxQuestionSize || inString.characters.count <= 0 {
            return []
        }

        let separators = NSCharacterSet.whitespacesAndNewlines
        let words = inString.components(separatedBy: separators)
        var wordIndex = 0

        for i in 0 ... 3 {
            var lineLength = 0
            var lineStr = ""

            while lineLength <= maxLineLength {
                if wordIndex > words.count - 1 {
                    break
                } else {
                    if lineLength + words[wordIndex].characters.count + 1 <= maxLineLength {
                        if wordIndex == 0 {
                            lineStr = words[wordIndex]
                        } else {
                            lineStr = "\(lineStr) \(words[wordIndex])"
                        }
                        lineLength = lineStr.characters.count
                        wordIndex += 1
                    } else {
                        lineLength = maxLineLength + 1
                    }
                }
            }
            multiQuestion[i] = lineStr
        }
        if wordIndex < words.count {
            return []
        }
        return multiQuestion
    }

    /**
     This concatenates the questions and answers into a way that is easy to understand when
     read aloud by the Watson Text to Speech API
     */
    func concatQuestionAnswerText(question: Question) -> String {
        if gameVC.currentQuestion.correct.characters.count > 0 {
            return question.question + " 1. " + question.ansArray[0] + ". 2. " + question.ansArray[1]
                + ". 3. " + question.ansArray[2] + ".  Or 4. " + question.ansArray[3]
        }
        return ""
    }
}
