import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibestream/providers/post_provider.dart';
import 'package:vibestream/providers/reply_provider.dart';
import 'package:vibestream/presentation/main_screen.dart';
import 'package:vibestream/domain/services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PostProvider(ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ReplyProvider(ApiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Video Feed App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
      ),
    );
  }
}
