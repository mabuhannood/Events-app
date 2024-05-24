//
//  SigninView.swift
//  Group3
//
//  Created by Mohammad AbuHannood on 2023-07-08.
//

import SwiftUI

struct SigninView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showSignUp = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @Binding var rootScreen :RootView
    
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var userProfileController: UserProfileController
    
    var body: some View {
            VStack {
                Spacer()
                Text("Sign In")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)

                
                Image("Intro")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 30)


                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                Button(action: {
                    signIn()
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color(UIColor(named:"Color") ?? UIColor(Color.indigo)))
                        .cornerRadius(10.0)
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                NavigationLink(destination: SignUpView(rootScreen: self.$rootScreen).environmentObject(authController).environmentObject(userProfileController), isActive: $showSignUp) {
                    HStack{
                        Text("New Here? ")
                            .foregroundColor(.black)
                        Text("Sign up.")
                            .foregroundColor(.pink)
                            .fontWeight(.semibold)
                    }
                    .padding(.top, 20)
                }
                Spacer()
            }
          
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
    }
    
    // Function to handle sign in
    func signIn() {
        if !password.isEmpty && !email.isEmpty {
            // Call sign in method from authController
            authController.signIn(email: email, password: password) { result in
                switch result {
                case .success(let user):
                    print("User signed in successfully with email: \(user.email ?? "")")
                    userProfileController.getAllUserData(){
                        //populate data
                    }
                    // Fetch user profile data
                    self.userProfileController.getAllUserData {
                        UserDefaults.standard.set(email, forKey: "KEY_EMAIL")
                        UserDefaults.standard.set(password, forKey: "KEY_PASSWORD")
                        // update view properties inside completion handler
                        self.rootScreen = .Home
                    }
                    // Sign in error
                case .failure(let error):
                    print("Error while signing in: \(error.localizedDescription)")
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        } else {
            // Show an alert if passwords do not match
            alertMessage = "Passwords do not match"
            showingAlert = true
        }
    }
}

//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}
