//
//  UpComingController.swift
//  JapWork
//
//  Created by Taylor McLaughlin on 5/17/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This view controller holds a table view that has each of the study objects of the data passed
//  in by the quiz or study controller.  Starting at the study object currently in the quiz or study controller
//  and going to the study object directly before this one.
//

import UIKit

protocol UpcomingControllerDelegate: AnyObject {
    func didSelect(forIndex index: Int)
}

private let reuseIdentifier = "UpComingCell"

class UpcomingController: UIViewController {
    
    //MARK: - Properties:
    
    var tableView: UITableView!
    var wordKanjiInfo: [StudyObject]!
    var offSet: Int!
    var delegate: UpcomingControllerDelegate!
    var isQuiz: Bool!
    
    //MARK: - Init:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - Handlers:
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UpComingCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .black
        
        tableView.rowHeight = 60
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
}

extension UpcomingController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordKanjiInfo.count
    }
    
    // If in quiz format, then only present the name of the vocab/kanji, if not in quiz format, present
    // the name and meaning in english of the vocab/kanji.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UpComingCell
        var i = 0
        if indexPath.row + offSet >= wordKanjiInfo.count {
            i = offSet + indexPath.row - wordKanjiInfo.count
        } else {
            i = offSet + indexPath.row
        }
        
        if wordKanjiInfo[i].identifier == "Kanji" {
            let kanji = wordKanjiInfo[i] as! Kanji
            if isQuiz {
                cell.studyObjectLabel.text = kanji.object
            } else {
                cell.studyObjectLabel.text = kanji.object + ": " + kanji.imaAnswer[0]
            }
        } else if wordKanjiInfo[i].identifier == "Vocab" {
            let word = wordKanjiInfo[i] as! Word
            if isQuiz {
                cell.studyObjectLabel.text = word.object
            } else {
                cell.studyObjectLabel.text = word.object + ": " + word.imaAnswer
            }
        }
        return cell
    }
    
    // When a row is selected, get the proper index of the kanji/vocab in the data of the study or quiz
    // controller that opened the upcoming controller and then call the delegate's didSelect function
    // using that index
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var i = 0
        if indexPath.row + offSet > wordKanjiInfo.count {
            i = offSet - indexPath.row
        } else {
            i = indexPath.row + offSet
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UpComingCell
        if cell.studyObjectLabel.text == "Start:" {
            return
        }
        
        delegate.didSelect(forIndex: i)
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
