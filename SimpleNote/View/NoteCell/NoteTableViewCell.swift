//
//  NoteTableViewCell.swift
//  SimpleNote
//
//  Created by ParaBellum on 9/29/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with note:Note){
        noteTitleLabel.text = note.noteTitle
        if let noteContent = note.noteContent{
            noteContentLabel.text = noteContent
        }else{
            noteContentLabel.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
