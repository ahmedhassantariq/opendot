import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/services/auth/auth_gate.dart';
import 'package:reddit_app/services/auth/auth_service.dart';
import 'package:reddit_app/services/chat/chat_services.dart';
import 'package:reddit_app/services/firebase/firebase_options.dart';
import 'package:reddit_app/services/firebase/firebase_services.dart';
import 'package:reddit_app/services/hub/hub_services.dart';
import 'package:reddit_app/services/posts/post_services.dart';


// -d chrome --web-renderer html

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>AuthService()),
          ChangeNotifierProvider(create: (context)=>FirebaseServices()),
          ChangeNotifierProvider(create: (context)=>HubServices()),
          ChangeNotifierProvider(create: (context)=>PostServices()),
          ChangeNotifierProvider(create: (context)=>ChatServices()),
        ],
        child: const MyApp(),
      )
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return FractionallySizedBox(
        widthFactor: kIsWeb ? (screenWidth < 500 ? 1.0 : 500 / screenWidth) : 1.0,
        child: MaterialApp(
        debugShowCheckedModeBanner: false,

        scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
        title: 'Open Dot',
        home: const AuthGate()

        )
      );
  }
}