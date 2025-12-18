import SwiftUI

func permissionSettingsElementViewGenerator(title: String, condition: Bool, isConditionMatchedElement: some View, isConditionUnMatchedElement: some View) -> some View {
    VStack{
        HStack{
            Text(title)
            Spacer()
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
        
        HStack{
            Spacer()
            if condition {
                isConditionMatchedElement
            }
            else{
                isConditionUnMatchedElement
            }
        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
    }
}
