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

class ScoreController {

    var baseScore: Int
    var accuracyBonus: Int
    var questionsAsked: Int
    var difficultyBonus: Int
    var finalScore: Int
    var correctAnswers: Int
    var comboCount: Int
    var comboBonus: Int

    init() {
        baseScore = 0
        accuracyBonus = 0
        questionsAsked = 0
        difficultyBonus  = 0
        finalScore = 0
        correctAnswers = 0
        comboCount = 0
        comboBonus = 0
    }

    /**
        Calculate the final score for fields that are not recalculated for each question
     */
    func calculateScore() {
        baseScore = maxCorrect * 100
        accuracyBonus = 1000 * correctAnswers / maxCorrect
        finalScore = baseScore + accuracyBonus + difficultyBonus
    }

    /**
        Set the final score with the combo bonus included
     */
    func addComboBonus() -> Int {
        finalScore += comboBonus
        return finalScore
    }

    /**
        Reset all score variables to 0 at the end of the round
     */
    func resetScores() {
        baseScore = 0
        accuracyBonus = 0
        questionsAsked = 0
        difficultyBonus = 0
        finalScore = 0
        correctAnswers = 0
        comboCount = 0
        comboBonus = 0
    }

    /**
        Increment the scores for the results of each question
     */
    func scoreIncrement(question: Question) {
        correctAnswers += 1
        if question.timesCorrect > 0 {
            difficultyBonus += ((100 * question.timesAttempted) / question.timesCorrect)
        } else {
            difficultyBonus += 100
        }
        comboCount += 1
        comboBonus += (comboCount * 10)
    }
}
