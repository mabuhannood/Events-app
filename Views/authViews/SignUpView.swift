//
//  SignUpView.swift
//  Group3
//
//  Created by Mohammad AbuHannood on 2023-07-08.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var name = ""
    @State var contactNumber: String = ""
    
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var userProfileController: UserProfileController
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var rootScreen :RootView
    
    var body: some View {
        VStack {
            Spacer()
            Text("Sign Up")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)
            
            VStack{
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                TextField("Contact Number", text: $contactNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .keyboardType(.phonePad)

            }
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom, 10)
            
            HStack {
                
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                
            
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            HStack {
               
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                
             
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            
            Button(action: {
                signUp()
            }, label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 60)
                    .background(Color(UIColor(named:"Color") ?? UIColor(Color.indigo)))
                    .cornerRadius(10.0)
            })
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            HStack {
                Text("Already a user?")
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Log in")
                        .foregroundColor(.pink)
                        .fontWeight(.semibold)
                })
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Function to handle sign up
    private func signUp(){
        // Display error message for contactNumber length
        if !(self.contactNumber.count == 10)  {
            // Display error message for carPlateNumbers length
            alertMessage = "Please enter a valid (10 Digits) contact phone"
            showingAlert = true
            return
        }
        // Check email and password validity
        if(isValidEmail(email) && isValidPassword(password) && password == confirmPassword){
            
            // Sign up the user with Firebase Auth
            print("password", password, email)
            authController.signUp(email: email, password: password) { result in
                switch result {
                case .success(_):
                    let user = UserProfile(name: name.lowercased(), email: email, password: password, contactNumber: contactNumber)
                    userProfileController.insertUserData(newUserData: user)
                    userProfileController.getAllUserData(){
                        //populate data
                    }
                    // update the userProfile in the profile helper
//                    var newUser = UserProfile(name: self.name, email: self.email, password: self.password, contactNumber: self.contactNumber, carPlateNumbers: [carPlateNumbers])
//                    userProfileController.insertUserData(newUserData: newUser)
//                    userProfileController.userProfile = newUser
                    // Navigate to the Home screen upon successful sign up
                    self.rootScreen = .Home
                    
                    // show error msg
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
            
        } else {
            // Display error message for email and password
            alertMessage = "Please enter a valid email and password"
            showingAlert = true
        }
    }
    // Function to check if the email is valid
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    // Function to check if the password is valid
    private func isValidPassword(_ password: String) -> Bool {
        // Add your password validation criteria here
        return password.count >= 6
    }
}



//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
