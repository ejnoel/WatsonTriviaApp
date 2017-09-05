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

class ServerConnect {

    var serverString : String = "https://localhost:8080/" /// This needs to be the server URL
    var questionController: QuestionController!
    var gameVC: GameViewController!
    var jsonErrCount: Int = 0

    init() {}

    /**
     Send a request to get a single question
     */
    func getQuestionServerRequest() {
        serverRequest(requestString: "getquestion")
    }

    /**
     Send a request to get multiple questions
     */
    func getQuestionsServerRequest() {
        serverRequest(requestString: "getquestions")
    }

    /**
     This is a generic server request. It can be used to get one or multiple questions from 
     the server. It gets and stores the session id cookie specified by the server as well, 
     which prevents duplicate questions from being sent.
     */
    func serverRequest(requestString: String) {
        ///Set up the URL for the request
        var getRequestString = serverString.appending(requestString)
        if gameVC.getServerLanguage().characters.count > 0 {
            getRequestString = getRequestString.appending("/\(gameVC.getServerLanguage())")
        }
        let getRequestURL = URL(string: getRequestString)
        var request = URLRequest(url: getRequestURL!)

        /// If we have a session ID, set it in the header field of "Set-Cookie" which will be included in the request
        if gameVC.sessionID.characters.count > 0 {
            request.setValue(gameVC.sessionID, forHTTPHeaderField: "Set-Cookie")
        }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 5
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            /// We only want to display an error if we got an error from the server and we don't have any
            /// questions left in the queue
            guard error == nil else {
                if self.gameVC.currentQuestion.question.characters.count == 0
                    && self.questionController.questionQueue.count == 0 {
                    self.gameVC.alertActionServer()
                }
                return
            }

            /// Again, only display an error if we don't have any questions left to ask
            guard let data = data else {
                if self.gameVC.currentQuestion.question.characters.count == 0
                    && self.questionController.questionQueue.count == 0 {
                    self.gameVC.alertActionServer()
                }
                return
            }

            /// If the response includes the "Set-Cookie" header field, we should save it for the next request
            if let httpUrlResponse = response as? HTTPURLResponse {
                if let cookie = httpUrlResponse.allHeaderFields["Set-Cookie"] as? String {
                    self.gameVC.sessionID = cookie
                }
            }

            /// Parse the json -- can be one or multiple questions depending on the request
            self.parseData(data: data)
        })
        task.resume()
    }

    /**
     Send the question ID and a boolean indicating whether or not the user answered the question
     correctly. The server will use this to adjust the variables used in the difficulty score.
     
     This is a 'best do' situation. We will print a message if there is an error, but will continue
     processing as normal
     */
    func postQuestionResult(answerData: Dictionary<String, Any>) {
        let postRequestString = serverString.appending("answer")
        let postRequestURL = URL(string: postRequestString)
        var request = URLRequest(url: postRequestURL!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        if let jsonData = try? JSONSerialization.data(withJSONObject: answerData, options: .prettyPrinted) {
            request.httpBody = jsonData

            let task = session.dataTask(with: request, completionHandler: { _, response, error in

                guard error == nil else {
                    print("Error sending question response data to server")
                    return
                }

                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("Error: expected status code 200, got \(httpStatus.statusCode)")
                }
            })
            task.resume()
        }
    }

    /**
     Parse the data that comes back from the http request
     */
    func parseData(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSArray {
                for q in json {
                    if let dict = q as? NSDictionary {
                        if let questionText = dict.value(forKey: "question") as? String,
                            let ans1Text = dict.value(forKey: "answer1") as? String,
                            let ans2Text = dict.value(forKey: "answer2") as? String,
                            let ans3Text = dict.value(forKey: "answer3") as? String,
                            let ans4Text = dict.value(forKey: "answer4") as? String,
                            let correctAns = dict.value(forKey: "correct") as? String,
                            let timesAttempted = dict.value(forKey: "timesAttempted") as? Int,
                            let timesCorrect = dict.value(forKey: "timesCorrect") as? Int,
                            let id = dict.value(forKey: "id") as? String {
                            let question = Question(qID: id, question: questionText,
                                                    ansText1: ans1Text, ansText2: ans2Text,
                                                    ansText3: ans3Text, ansText4: ans4Text,
                                                    correct: correctAns, timesAttempted: timesAttempted,
                                                    timesCorrect: timesCorrect)
                            if question.correct.trimmingCharacters(in: .whitespaces).characters.count > 0 {
                                if self.gameVC.currentQuestion.correct.characters.count == 0 {
                                    self.gameVC.currentQuestion = question
                                } else {
                                    self.questionController.questionQueue.append(question)
                                }
                            }
                        }
                    }
                }
                if self.questionController.questionQueue.count < 4 {
                    self.getQuestionServerRequest()
                }
                self.jsonErrCount = 0
            }
        } catch _ {
            /// If we failed to parse a question and don't have any questions currently available, we want to
            /// reset the currentQuestion object so that it causes the didSet for that item to be called
            if self.jsonErrCount < 10 {
                if self.gameVC.currentQuestion.question.characters.count == 0
                    && self.questionController.questionQueue.count == 0 {
                    self.jsonErrCount += 1
                    self.gameVC.currentQuestion = Question()
                }
            } else {
                self.gameVC.alertActionServer()
                self.jsonErrCount = 0
            }
        }
    }
}
