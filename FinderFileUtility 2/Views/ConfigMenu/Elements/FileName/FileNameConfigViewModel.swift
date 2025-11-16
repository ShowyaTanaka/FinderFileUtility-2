//
//  FileNameViewModel.swift
//  FinderFileUtility 2
//
//  Created by Noel Light on 2025/04/24.
//

import Foundation
import SwiftUI

@Observable class FileNameConfigViewModel{
    var fileNameForDisplay:String = ""
    var beforeEditingFileName: String = ""
    
    init(){
        let current_default_name_data: String = FileNameService.getDefaultFileNameData()
        self.fileNameForDisplay = current_default_name_data
        self.beforeEditingFileName = current_default_name_data
    }
    
    func resetFileNameForDisplay(){
        self.fileNameForDisplay = self.beforeEditingFileName
    }
    
    func updateDefaultFileNameData(fileName: String){
        FileNameService.writeDefaultFileNameData(newFileName: fileName)
        self.beforeEditingFileName = fileName
    }
    
    
}
