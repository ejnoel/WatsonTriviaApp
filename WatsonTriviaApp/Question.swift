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

/**
 This class defines the structure of the questions being returned from the server
 */
class Question {
    var qID: String = ""
    var question: String = ""
    var ansArray: [String] = ["", "", "", ""]
    var correct: String = ""
    var timesAttempted: Int = 0
    var timesCorrect: Int = 0
    var answered: Bool = false

    init(qID: String, question: String, ansText1: String, ansText2: String, ansText3: String, ansText4: String,
         correct: String, timesAttempted: Int, timesCorrect: Int) {
        self.qID = qID
        self.question = question
        self.ansArray[0...3] = [ansText1, ansText2, ansText3, ansText4]
        self.correct = correct
        self.timesCorrect = timesCorrect
        self.timesAttempted = timesAttempted
    }

    init() {
    }
}
