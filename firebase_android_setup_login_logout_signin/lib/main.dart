import 'package:firebase_android_setup/model/board.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Board> boardMessage = List();
  Board board;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    board = Board('', '');
    databaseReference = database.reference().child('community_board');
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Board'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
              flex: 0,
              child: Center(
                child: Form(
                  key: formKey,
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.subject),
                        title: TextFormField(
                          initialValue: '',
                          onSaved: (val) => board.subject = val,
                          validator: (val) => val == '' ? val : null,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.message),
                        title: TextFormField(
                          initialValue: '',
                          onSaved: (val) => board.body = val,
                          validator: (val) => val == '' ? val : null,
                        ),
                      ),
                      FlatButton(
                        child: Text('Post'),
                        color: Colors.redAccent,
                        onPressed: () {
                          handleSubmit();
                        },
                      )
                    ],
                  ),
                ),
              )),
          Flexible(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                    ),
                    title: Text(boardMessage[index].subject),
                    subtitle: Text(boardMessage[index].body),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      boardMessage.add(Board.fromSnapshot(event.snapshot));
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();

      databaseReference.push().set(board.toJson());
    }
  }

  void _onEntryChanged(Event event) {
    var oldEntry = boardMessage.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      boardMessage[boardMessage.indexOf(oldEntry)] =
          Board.fromSnapshot(event.snapshot);
    });
  }
}


//import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//
//final FirebaseAuth _auth = FirebaseAuth.instance;
//final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//
//        primarySwatch: Colors.blue,
//      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//
//  String imageUrl;
//  String defaultImageUrl = 'https://picsum.photos/250?image=9';
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//
//        title: Text('Board'),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Image.network(imageUrl == null || imageUrl.isEmpty
//                ? defaultImageUrl
//                : imageUrl),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: FlatButton(
//                child: Text('Google Sign in'),
//                onPressed: () => _gSignIn(),
//                color: Colors.redAccent,
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: FlatButton(
//                child: Text('Signin with email'),
//                color: Colors.purple,
//                onPressed: () => _signInWithEmail(),
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: FlatButton(
//                child: Text('Create Account'),
//                color: Colors.pinkAccent,
//                onPressed: () => _createUser(),
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: FlatButton(
//                child: Text('Log Out'),
//                color: Colors.greenAccent,
//                onPressed: () => _logout(),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Future<FirebaseUser> _gSignIn() async {
//    GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
//    GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//
//    final FirebaseUser user = await _auth.signInWithCredential(credential);
//
////    assert(user.email != null);
////    assert(user.displayName != null);
////    assert(!user.isAnonymous);
////    assert(await user.getIdToken() != null);
//
////    final FirebaseUser currentUser = await _auth.currentUser();
////    assert(user.uid == currentUser.uid);
//
//    print('signInWithGoogle succeeded! \n Name: ${user.displayName}\n' +
//        'Email: ${user.email}');
//
//    setState(() {
//      imageUrl = user.photoUrl;
//    });
//    print('Url: ' + imageUrl);
//    return user;
//  }
//
//  Future _createUser() async {
//    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
//        email: 'rishabhdhfhf@gmail.com', password: '123456test').then((user) {
//          print('Username: ${user.displayName}');
//    });
//
//    print('Email: ${user.email}');
//  }
//
//  _logout() {
//
//    //_auth.signOut(); //for general sign out
//    setState(() {
//      _googleSignIn.signOut();//for google sign out
//      imageUrl = null;
//    });
//
//  }
//
//  _signInWithEmail() {
//    _auth.signInWithEmailAndPassword(email: 'rishabhdhfhf@gmail.com', password: '123456test').then((user) {
//      print('${user.email} signed in!');
//    }).catchError((e) {
//      print('Something went wrong: ${e.toString()}');
//    });
//
//  }
//}
