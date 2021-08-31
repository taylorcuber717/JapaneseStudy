//
//  UpComingController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/17/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

protocol UpComingControllerDelegate: class {
    func didSelect(forIndex index: Int)
}

private let reuseIdentifier = "UpComingCell"

class UpComingController: UIViewController {
    
    //MARK: - Properties:
    
    var tableView: UITableView!
    var wordKanjiInfo: [StudyObject]!
    var offSet: Int!
    var delegate: UpComingControllerDelegate!
    
    //MARK: - Init:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - Handlers:
    
    func configureTableView() {
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

extension UpComingController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordKanjiInfo.count
    }
    
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
            cell.studyObjectLabel.text = kanji.object + ": " + kanji.imaAnswer[0]
        } else if wordKanjiInfo[i].identifier == "Vocab" {
            let word = wordKanjiInfo[i] as! Word
            cell.studyObjectLabel.text = word.object + ": " + word.imaAnswer
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var i = 0
        if indexPath.row + offSet > wordKanjiInfo.count {
            i = offSet - indexPath.row
        } else {
            i = indexPath.row + offSet
        }
        delegate.didSelect(forIndex: i)
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
