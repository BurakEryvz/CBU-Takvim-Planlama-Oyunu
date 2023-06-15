//
//  EventCell.swift
//  cbuTakvim
//
//  Created by Burak Eryavuz on 20.05.2023.
//

import UIKit

class EventCell: UITableViewCell {
    
    
    @IBOutlet weak var konuLabel: UILabel!
    
    
    @IBOutlet weak var gonderenLabel: UILabel!
    
    
    @IBOutlet weak var saatLabel: UILabel!
    
    
    @IBOutlet weak var aciklamaLabel: UILabel!
    
    
    @IBOutlet weak var eventBubble: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Event hücresinin kenarlarinin yumusatilmasi icin yapilmistir.
        eventBubble.layer.cornerRadius = eventBubble.frame.height / 7
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
    }
    
}
