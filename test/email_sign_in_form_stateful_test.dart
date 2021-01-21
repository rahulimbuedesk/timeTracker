import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';


import 'mocks.dart';



void main() {

  MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });



  Future<void> pumpEmailSignInForm(WidgetTester tester, 
  {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
           home: Scaffold(body: EmailSignInFormStateful(
             onSignedIn: onSignedIn,
           )),  
        ),
      ),
    );
  }


void stubSignInWithEmailAndPasswordSucceeds(){
  when(mockAuth.signInWithEmailAndPassword(any, any))
      .thenAnswer((_) => Future<User>.value(MockUser()));
}


void stubSignInWithEmailAndPasswordThrows(){
  when(mockAuth.signInWithEmailAndPassword(any, any))
      .thenThrow(FirebaseAuthException(message: '', code: 'wrong password'));
}



group('sign in', () {

  
  testWidgets('when user dont enter the email and password and user taps on the sign-in button then signinwithemailandpassword is not called and user is not signed in', (WidgetTester tester) async{
    
    var signedIn = false;
    
    await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

    final signInButton = find.text('Sign in');
    await tester.tap(signInButton);

    verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
    expect(signedIn, false);
  });


  testWidgets('when user enter the email and password and user taps on the sign-in button then signinwithemailandpassword is  called', (WidgetTester tester) async{

    var signedIn = false;
    
    await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

    stubSignInWithEmailAndPasswordSucceeds();

    const email = 'email@email.com';
    const password = 'password';

    final emailField = find.byKey(Key('email'));
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);



    final passwordField = find.byKey(Key('password'));
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);


    await tester.pump();  

    final signInButton = find.text('Sign in');
    await tester.tap(signInButton);

    verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
    expect(signedIn, true);
  });

  



    testWidgets('when user enter the invalid email and password and user taps on the sign-in button then signinwithemailandpassword is  called and user is not signed in', (WidgetTester tester) async{

    var signedIn = false;
    
    await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

    stubSignInWithEmailAndPasswordThrows();

    const email = 'email@email.com';
    const password = 'password';

    final emailField = find.byKey(Key('email'));
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);



    final passwordField = find.byKey(Key('password'));
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);


    await tester.pump();  

    final signInButton = find.text('Sign in');
    await tester.tap(signInButton);

    verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
    expect(signedIn, false);
  });




});






group('register', () {

  
  testWidgets('when user taps on the secondary button then form toggles to registration mode', (WidgetTester tester) async{
    await pumpEmailSignInForm(tester);

    final registerButton = find.text('Need an account? Register');
    await tester.tap(registerButton);

    await tester.pump();

    final  createAccountButton = find.text('Create an account');
    expect(createAccountButton, findsOneWidget);

  });


  testWidgets('when user taps on the secondary button and user enters the email and password and user taps on the register button then createuserwithemailandpassword is called', (WidgetTester tester) async{
    await pumpEmailSignInForm(tester);

    const email = 'email@email.com';
    const password = 'password';


   final registerButton = find.text('Need an account? Register');
    await tester.tap(registerButton);

    await tester.pump();


    final emailField = find.byKey(Key('email'));
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);



    final passwordField = find.byKey(Key('password'));
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);


    await tester.pump();  

    final  createAccountButton = find.text('Create an account');
    expect(createAccountButton, findsOneWidget);
    await tester.tap(createAccountButton);

    verify(mockAuth.createUserWithEmailAndPassword(email, password)).called(1);
  });

  
});



}