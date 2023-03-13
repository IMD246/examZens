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
              flex: 6,
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
            return const Row(
              children: [
                Spacer(),
                CircularProgressIndicator(
                  color: Color(
                    0xff29b363,
                  ),
                ),
                Spacer(),
              ],
            );
          }
          return Column(
            children: [
              const Spacer(flex: 2),
              Expanded(
                flex: 10,
                child: Consumer<JokeProvider>(
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        value.listJokes.isEmpty
                            ? "That's all the jokes for today! Come back another day!"
                            : value.listJokes.first.content ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(
                            0xff6b6b6b,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: _likeButton(
                          press: () async {
                            await jokeProvider.processingGame(
                              value: true,
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 8,
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
              ),
              const Spacer(flex: 2),
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
        color: const Color(
          0xff29b363,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: const Text(
          "This is not Funny.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  InkWell _likeButton({required VoidCallback press}) {
    return InkWell(
      onTap: press,
      child: Container(
        color: const Color(
          0xff2c7edb,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: const Text(
          "This is Funny!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
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
      child: const Column(
        children: [
          Text(
            "This appis created as part of Hlosulutions program. The materials con-tained on this website are provided for general information only and do not constitute any form of advice. HLS assumes no responsibility for the accuaracy of any particular statement and accepts no liability for any loss or damage which may arise from reliance on the infor-mation contained on this site.",
            style: TextStyle(
              fontSize: 11,
              color: Color(
                0xff6f6f6f,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text(
              "Copyright 2021 HLS",
              style: TextStyle(
                fontSize: 11,
                color: Color(
                  0xff6b6b6b,
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
      color: const Color(
        0xff29b363,
      ),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Spacer(flex: 3),
          Text(
            "A joke a day keeps the doctor away",
            style: TextStyle(
              color: Color(0xffffffff),
              fontSize: 15,
            ),
          ),
          Spacer(flex: 2),
          Text(
            "If you joke wrong way, your teeth have to pay. (Serious)",
            style: TextStyle(
              color: Color(0xffffffff),
              fontSize: 10,
            ),
          ),
          Spacer(flex: 3),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/icons/ic_app.png",
            fit: BoxFit.contain,
            width: 64,
            height: 64,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(flex: 2),
                  Text(
                    "Handicrafted by",
                    style: TextStyle(
                      color: Color(
                        0xff949494,
                      ),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    "Jim HLS",
                    style: TextStyle(
                      color: Color(
                        0xff6b6b6b,
                      ),
                      fontSize: 9,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(
                width: 2,
              ),
              Image.asset(
                "assets/icons/ic_avatar.png",
                fit: BoxFit.contain,
                width: 64,
                height: 64,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
