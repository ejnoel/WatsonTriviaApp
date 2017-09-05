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
 This class defines a rocket with all the strings set for each country and language
 */
class InternationalRocket {
    var language: String!
    var languageString: String!
    var settingsRocket: String!
    var rocketParts: [String] = [String]()
    var rocketVoice: String!
    var rocketBroadband: String!
    var languageConstants: LanguageText!

    init(languageAccent: String) {
        switch languageAccent {
        case "gb" :
            setGBRocket()
        case "es" :
            setSpainRocket()
        case "mx" :
            setMexRocket()
        default:
            setUSARocket()
        }
    }

    func setGBRocket() {
        language = "en"
        languageString = "gb"
        settingsRocket = "rocket_kate_gb"
        rocketParts.removeAll()
        for i in 1...maxCorrect {
            rocketParts.append("rocket_gb_\(i)")
        }
        rocketVoice = "en-GB_KateVoice"
        rocketBroadband = "en-GB_BroadbandModel"
        languageConstants = LanguageText(language: language)
    }

    func setUSARocket() {
        language = "en"
        languageString = "us"
        settingsRocket = "rocket_michael_usa"
        rocketParts.removeAll()
        for i in 1...maxCorrect {
            rocketParts.append("rocket_usa_\(i)")
        }
        rocketVoice = "en-US_MichaelVoice"
        rocketBroadband = "en-US_BroadbandModel"
        languageConstants = LanguageText(language: language)
    }

    func setMexRocket() {
        language = "es"
        languageString = "mx"
        settingsRocket = "rocket_sofia_mex"
        rocketParts.removeAll()
        for i in 1...maxCorrect {
            rocketParts.append("rocket_mex_\(i)")
        }
        rocketVoice = "es-LA_SofiaVoice"
        rocketBroadband = "es-ES_BroadbandModel"
        languageConstants = LanguageText(language: language)
    }

    func setSpainRocket() {
        language = "es"
        languageString = "es"
        settingsRocket = "rocket_enrique_spain"
        rocketParts.removeAll()
        for i in 1...maxCorrect {
            rocketParts.append("rocket_es_\(i)")
        }
        rocketVoice = "es-ES_EnriqueVoice"
        rocketBroadband = "es-ES_BroadbandModel"
        languageConstants = LanguageText(language: language)
    }
}
