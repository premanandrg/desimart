import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../FIREBASE/firebase_config.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.nextPage}) : super(key: key);

  final Widget nextPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            try {
              await signInWithGoogle(context: context).then((user) async {
                if (user != null) {
                  await usersRef.doc(user.uid).get().then((value) async {
                    if (value.exists) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return nextPage;
                      }), (route) => false);
                    } else {
                      //TODO add user data to server
                      Map<String, dynamic> userMap = {
                        'displayName': user.displayName,
                        'profilePic': user.photoURL,
                        'created':
                            Timestamp.fromDate(user.metadata.creationTime!),
                        'timestamp': Timestamp.now(),
                        'email': user.email,
                      };
                      await usersRef.doc(user.uid).set(userMap);

                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return nextPage;
                      }), (route) => false);
                    }
                  });
                } else {
                  SnackBar snackBar =
                      const SnackBar(content: Text('Login Failed'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              });
            } catch (e) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: AppBar().preferredSize.height - 5,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset('assets/images/google.png'),
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: AutoSizeText(
                      'Sign in with Google',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<User?> signInWithGoogle({required BuildContext context}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
      } else if (e.code == 'invalid-credential') {
        // handle the error here

        Navigator.of(context).pop();
      }
    } catch (e) {
      Navigator.of(context).pop();
      // handle the error here
    }
  }

  return user;
}
