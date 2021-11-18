//
//  ViewController.swift
//  Hangman
//
//  Created by Andres Marquez on 2021-11-04.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    var titleLabel: UILabel!
    var guessWords = ["Dog": "Dalmatian", "Emperor": "Augustus", "Brand": "Apple", "Game": "Zelda"]
    var remainingLife: UILabel!
    var clueLabel: UILabel!
    var answerLabel: UILabel!
    var letterAnswers = [String]()
    var inputField: UITextField!
    var answer = ""
    
    var usedLetters = [String]()
    
    var life = 7 {
        didSet {
            remainingLife.text = String(repeating: "❤️", count: life)
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.text = "H@ngm@n"
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        remainingLife = UILabel()
        remainingLife.translatesAutoresizingMaskIntoConstraints = false
        remainingLife.text = "❤️❤️❤️❤️❤️❤️❤️"
        remainingLife.font = UIFont.systemFont(ofSize: 18)
        remainingLife.numberOfLines = 0
        view.addSubview(remainingLife)
        
        clueLabel = UILabel()
        clueLabel.translatesAutoresizingMaskIntoConstraints = false
        clueLabel.font = UIFont.systemFont(ofSize: 24)
        clueLabel.text = "CLUE"
        clueLabel.numberOfLines = 0
        view.addSubview(clueLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.text = "Test"
        answerLabel.font = UIFont.systemFont(ofSize: 36)
        answerLabel.numberOfLines = 0
        view.addSubview(answerLabel)
        
        inputField = UITextField()
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.placeholder = "Letter here"
        inputField.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(inputField)
        
        startGame()
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            remainingLife.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            remainingLife.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clueLabel.topAnchor.constraint(equalTo: remainingLife.bottomAnchor, constant: 20),
            clueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerLabel.topAnchor.constraint(equalTo: clueLabel.bottomAnchor, constant: 20),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputField.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 50),
            inputField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submit.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: 50),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.delegate = self
    }
    
    @objc func startGame() {
        let guessWord = guessWords.randomElement()
        clueLabel.text = guessWord?.key ?? ""
        answer = guessWord?.value ?? ""
        
        var labelText = ""
        for _ in 0..<answer.count {
            // Give the label temporary text
            labelText.append("_ ")
        }
        answerLabel.text = labelText
        
        letterAnswers = []
        for letter in answer {
            let strLetter = String(letter)
            letterAnswers.append(strLetter)
        }
        
        usedLetters = []
        inputField.text = ""
        
        life = 7
    }
    
    @objc func submitTapped() {
        var tracker = 0
        if usedLetters.contains(inputField.text!) && life >= 1 {
            life -= 1
            if life == 0 {
                gameOver()
                return
            } else {
                let ac = UIAlertController(title: "Wrong Guess", message: "Please try again", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Keep trying!", style: .default))
                present(ac, animated: true)
                return
            }
        }
        for (index, letter) in letterAnswers.enumerated() {
            if letter.capitalized == inputField.text! {
                tracker += 1
                usedLetters.append(inputField.text!)
                var splitAnswers = answerLabel.text?.components(separatedBy: " ")
                splitAnswers?[index] = letter
                answerLabel.text = splitAnswers?.joined(separator: " ")
            }
        }
        if tracker == 0 && life >= 1 {
            life -= 1
            if life == 0 {
                gameOver()
                return
            } else {
                let ac = UIAlertController(title: "Wrong Guess", message: "Please try again", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Keep trying!", style: .default))
                present(ac, animated: true)
                return
            }
        }
        
        if answerLabel.text?.contains("_") == false {
            let ac = UIAlertController(title: "Success!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Start Again", style: .default))
            present(ac, animated: true)
            startGame()
            return
        }
    }
    
    func gameOver() {
        let ac = UIAlertController(title: "Game Over!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Start Again", style: .default))
        present(ac, animated: true)
        startGame()
    }

    // Limit number of possible characters in text field to 1
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // Attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // Add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // Make sure the result is under 1 characters
        return updatedText.count <= 1
    }
}

