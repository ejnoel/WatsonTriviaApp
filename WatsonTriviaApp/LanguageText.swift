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

class LanguageText {

    var retryName: String!
    var exitName: String!
    var titleName: String!
    var baseScore: String!
    var accuracy: String!
    var difficulty: String!
    var final: String!
    var bonus: String!
    var highS: String!
    var quit: String!
    var tryAgain: String!
    var serverString: String!

    init(language: String) {
        if language == "es" {
            setSpanish()
        } else {
            setEnglish()
        }
    }

    func setEnglish() {
        retryName = "retry"
        exitName = "exit"
        titleName = "trivia_title"
        baseScore = "Base score: "
        accuracy = "Accuracy bonus: "
        difficulty = "Difficulty bonus: "
        final = "Final Score: "
        bonus = " combo bonus!"
        highS = "High score: "
        quit = "Quit"
        tryAgain = "Try again"
        serverString = "Unable to connect to server. Try again or quit to main menu."

    }

    func setSpanish() {
        retryName = "retry_es"
        exitName = "exit_es"
        titleName = "trivia_title_es"
        baseScore = "Puntuación de base: "
        accuracy = "Precisión: "
        difficulty = "Dificultad: "
        final = "Puntuación final: "
        bonus = " puntos de combo!"
        highS = "Puntuación alta: "
        quit = "Salir"
        tryAgain = "Intenta de nuevo"
        serverString = "No se puede conectar al servidor. Inténtelo otra vez o salir al menú principal."
    }
}
