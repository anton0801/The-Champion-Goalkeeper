import SwiftUI

struct GameChooserView: View {
    
    @Environment(\.presentationMode) var presMode
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                     Image("champion_goalkeeper_icon")
                         .resizable()
                         .frame(width: 450, height: 450)
                     Spacer()
                 }
                
                VStack {
                    HStack {
                        VStack {
                            NavigationLink(destination: GoalkeeperGameView()
                                .navigationBarBackButtonHidden()) {
                                Image("goalkeeper")
                                    .resizable()
                                    .frame(width: 150, height: 60)
                            }
                            NavigationLink(destination: OffensiveGameView()
                                .navigationBarBackButtonHidden()) {
                                Image("offensive")
                                    .resizable()
                                    .frame(width: 150, height: 60)
                            }
                            NavigationLink(destination: FlyingBallView()
                                .navigationBarBackButtonHidden()) {
                                Image("flying_ball")
                                    .resizable()
                                    .frame(width: 150, height: 60)
                            }
                            Button {
                                presMode.wrappedValue.dismiss()
                            } label: {
                                Image("back_btn")
                                    .resizable()
                                    .frame(width: 100, height: 40)
                            }
                        }
                        Spacer()
                    }
                    .padding(.leading, 42)
                }
            }
            .background(
                Image("game_selection_bg")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    GameChooserView()
}
