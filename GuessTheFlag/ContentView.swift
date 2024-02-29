//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Leah Somerville on 2/8/24.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct FlagImage : View {
    var fileName: String
    
    var body: some View {
        Image(fileName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy",  "Monaco", "Nigeria", "Poland", "Russia" ,"Spain", "Uk", "Us"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    
    @State private var attempts = 0
    @State private var keepGoing = false
    @State private var attemptsTitle = ""
    
    
//    DAY 34
    @State private var rotateAmount = [0.0, 0.0, 0.0]
    @State private var opacityAmount = [1.0, 1.0, 1.0]
    @State private var scaleAmount = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                Text("Guess the Flag")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(fileName: countries[number])
                        }
//                       DAY 34
                        .rotation3DEffect(Angle(degrees: rotateAmount[number]), axis: (x: 0, y: 1, z: 0))
                        .opacity(opacityAmount[number])
                        .scaleEffect(scaleAmount[number])
                        .animation(.default, value: scaleAmount)
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 20))

                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Text("Attempts: \(attempts)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }.alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(score)")
            }
            .padding()
            
          }.alert(attemptsTitle, isPresented: $keepGoing) {
              Button("Reset", action: resetFunc)
          } message: {
              Text("Your final score is \(score). Would you like to restart?")
          }
    }

    
    func flagTapped(_ number: Int) {
//        DAY 34
        rotateAmount[number] += 360

        for notTapped in 0..<3 where notTapped != number {
            opacityAmount[notTapped] = 0.25
            scaleAmount[notTapped] = 0.50
        }
        
//
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That is the flag of \(countries[number])"
        }
        
        attempts += 1
        if attempts == 8 {
            if attempts == 3{
                attemptsTitle = "You didn't do to well"
            } else if attempts == 6{
                attemptsTitle = "Not to bad"
            } else {
                attemptsTitle = "Great Job!"
            }
            keepGoing = true
        }
        showingScore = true
//        DAY 34
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityAmount = [1.0, 1.0, 1.0]
        scaleAmount = [1.0, 1.0, 1.0]
    }
    
    func resetFunc() {
        score = 0
        attempts = 0
        
//        DAY 34
        opacityAmount = [1.0, 1.0, 1.0]
        scaleAmount = [1.0, 1.0, 1.0]
    }
}

#Preview {
    ContentView()
}
