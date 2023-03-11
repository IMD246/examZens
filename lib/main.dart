import 'package:flutter/material.dart';
import 'package:mobile_exam/services/local_storage.dart';
import 'package:mobile_exam/stateManager/joke_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPref = await SharedPreferences.getInstance();
  LocalStorage localStorage = LocalStorage(sharedPref: sharedPref);
  runApp(
    MyApp(
      localStorage: localStorage,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.localStorage});
  final LocalStorage localStorage;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<JokeProvider>(
      create: (context) => JokeProvider(
        localStorage: widget.localStorage,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final jokeProvider = Provider.of<JokeProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: _header(),
            ),
            Expanded(
              flex: 2,
              child: _body1(),
            ),
            Expanded(
              flex: 5,
              child: _body2(jokeProvider),
            ),
            Expanded(
              flex: 3,
              child: _footer(),
            ),
          ],
        ),
      ),
    );
  }

  Container _body2(JokeProvider jokeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: FutureBuilder(
        future: jokeProvider.initJoke(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return Column(
            children: [
              const Spacer(),
              Expanded(
                flex: 6,
                child: Consumer<JokeProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.listJokes.isEmpty
                          ? "That's all the jokes for today! Come back another day!"
                          : value.listJokes.first.content ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withOpacity(
                          0.6,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: _likeButton(
                        press: () async {
                          await jokeProvider.processingGame(
                            value: true,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Flexible(
                      flex: 2,
                      child: _dislikeButton(
                        press: () async {
                          await jokeProvider.processingGame(
                            value: false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }

  InkWell _dislikeButton({required VoidCallback press}) {
    return InkWell(
      onTap: press,
      child: Container(
        color: Colors.green.withOpacity(0.85),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: const Text(
          "This is not Funny.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  InkWell _likeButton({required VoidCallback press}) {
    return InkWell(
      onTap: press,
      child: Container(
        color: Colors.blue,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: const Text(
          "This is Funny!",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Container _footer() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Colors.black.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            "This appis created as part of Hlosulutions program. The materials con-tained on this website are provided for general information only and do not constitute any form of advice. HLS assumes no responsibility for the accuaracy of any particular statement and accepts no liability for any loss or damage which may arise from reliance on the infor-mation contained on this site.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(
                0.5,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              "Copyright 2021 HLS",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(
                  0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _body1() {
    return Container(
      color: Colors.green.withOpacity(0.8),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Spacer(flex: 3),
          Text(
            "A joke a day keeps the doctor away",
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 17,
            ),
          ),
          const Spacer(flex: 2),
          Text(
            "If you joke wrong way, your teeth have to pay. (Serious)",
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 12,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  Container _header() {
    return Container(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        right: 16,
        left: 24,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Image.asset(
          "assets/icons/ic_app.png",
          fit: BoxFit.contain,
          width: 64,
          height: 64,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Handicrafted by",
                  style: TextStyle(
                    color: Colors.black.withOpacity(
                      0.45,
                    ),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "Jim HLS",
                  style: TextStyle(
                    color: Colors.black.withOpacity(
                      0.8,
                    ),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Image.asset(
              "assets/icons/ic_avatar.png",
              fit: BoxFit.contain,
              width: 64,
              height: 64,
            ),
          ],
        ),
      ]),
    );
  }
}
