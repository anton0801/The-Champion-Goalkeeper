import SwiftUI

struct ScorredGameOverPopUp: View {
    
   @Environment(\.presentationMode) var presMode
   var score: Int
   
   var body: some View {
       ZStack {
           Image("game_over_bg")
               .resizable()
               .frame(minWidth: UIScreen.main.bounds.width,
                      minHeight: UIScreen.main.bounds.height)
               .ignoresSafeArea()
           
           Image("back_light")
               .resizable()
               .frame(width: 400, height: 800)
           
           VStack {
               Image("you_are_champion")
                   .resizable()
                   .frame(width: 300, height: 100)
                   .zIndex(5)
               
               VStack {
                   Image("stars_3")
                       .resizable()
                       .frame(width: 250, height: 150)
                   
                   HStack {
                       Text("+\(score)")
                           .font(.custom("Benzin-Bold", size: 24))
                           .foregroundColor(.white)
                       
                       Image("ball")
                           .resizable()
                           .frame(width: 24, height: 24)
                   }
                   
                   Button {
                       presMode.wrappedValue.dismiss()
                   } label: {
                       Image("back_btn")
                           .resizable()
                           .frame(width: 140, height: 50)
                   }
                   
                   Button {
                       NotificationCenter.default.post(name: Notification.Name("start_again"), object: nil)
                   } label: {
                       Image("start_again")
                           .resizable()
                           .frame(width: 140, height: 50)
                   }
               }
               .background(
                   Image("settings_pop_up_bg")
                       .resizable()
                       .frame(width: 300, height: 350)
               )
           }
           
       }
       .background(
           Rectangle()
               .fill(.black.opacity(0.1))
               .frame(minWidth: UIScreen.main.bounds.width,
                      minHeight: UIScreen.main.bounds.height)
               .ignoresSafeArea()
       )
   }
    
}

#Preview {
    ScorredGameOverPopUp(score: 5)
}
