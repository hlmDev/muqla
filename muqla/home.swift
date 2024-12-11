//
//  muqlaApp.swift
//  muqla
//
//  Created by Ahlam Majed on 10/12/2024.
//

import SwiftUI

struct home: View {
   var body: some View {
       TabView {
           BooksView()
               .tabItem {
                   Label("My books", systemImage: "book.closed")
               }
           
           ProfileView()
               .tabItem {
                   Label("Profile", systemImage: "person.circle")
               }
       }
       // this for change the color in bar
       .onAppear {
           let appearance = UITabBarAppearance()
           appearance.backgroundImage = UIImage(named: "colordarkgray")
           UITabBar.appearance().standardAppearance = appearance
           UITabBar.appearance().scrollEdgeAppearance = appearance
           UITabBar.appearance().unselectedItemTintColor = UIColor(named: "colorgray")
       }
       .tint(.white)
   }
}

struct BooksView: View {
   var body: some View {
       ZStack {
           Color.black.ignoresSafeArea()
           
           HStack {
               Text("Ready to write ?")
                   .font(.system(size: 34, weight: .bold))
                   .foregroundColor(.white)
               Spacer()
               Button(action: {}) {
                   Image(systemName: "plus.circle")
                       .font(.system(size: 35))
                       .foregroundColor(.white)
               }
           }
           .padding()
           .padding(.top, 60)
           .frame(maxHeight: .infinity, alignment: .top)
       }
   }
}

struct ProfileView: View {
   var body: some View {
       ZStack {
           Color.black.ignoresSafeArea()
           
           Text("Profile")
               .font(.system(size: 34, weight: .bold))
               .foregroundColor(.white)
               .frame(maxWidth: .infinity, alignment: .leading)
               .padding()
               .padding(.top, 60)
               .frame(maxHeight: .infinity, alignment: .top)
       }
   }
}

#Preview {
   home()
      // .preferredColorScheme(.dark)
}
