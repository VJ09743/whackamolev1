import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ypnfuffzlroonssdweib.supabase.co',
    anonKey: 'sb_publishable_lZBQWeKrUBH47DUaP5mMAg_u2zX9X1t',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whackamole',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      home: loginpage(),
    );
  }
}
class loginpage extends StatefulWidget {
  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final _formKey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordController = TextEditingController();

  void submit() async {
    if (_formKey.currentState!.validate()) {
      final email = '${_emailcontroller.text}@whackamole.jorithm.net';
      final password = _passwordController.text;
      try {
        await Supabase.instance.client.auth.signInWithPassword(password: password, email: email);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              MyHomePage(
                title: 'WHACKAMOLE', username: _emailcontroller.text,)),
        );
      }
      catch (error){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),));
      }
    }
  }
  void signup() async {
    if (_formKey.currentState!.validate()) {
      final email = '${_emailcontroller.text}@whackamole.jorithm.net';
      final password = _passwordController.text;
      try {
        await Supabase.instance.client.auth.signUp(password: password, email: email);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              MyHomePage(
                title: 'WHACKAMOLE', username: _emailcontroller.text,)),
        );
      }
      catch (error){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Card(
            color: Colors.blueGrey,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text("Sign In", style: Theme.of(context).textTheme.headlineMedium),
                    TextFormField(
                      controller: _emailcontroller,
                      decoration: InputDecoration(labelText: "Username", hint: Text("Not case sensitive"), border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Username is required';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password is required';
                        return null;
                      },
                    ),
                    FilledButton(onPressed: submit, child: Text("Sign In")),
                    FilledButton(onPressed: signup, child: Text("Sign Up")),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.username});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  final String username;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _x = 50;
  double _y = 50;
  double _avgtime = 0.0000;
  Random randx = Random();
  Random randy = Random();
  List<Duration> times = [];
  var stopwatch = Stopwatch();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      stopwatch.stop();
      times.add(stopwatch.elapsed);
      stopwatch.reset();
      _avgtime = 0;
      for (var time in times) {
        _avgtime += time.inMilliseconds;
      }
      _avgtime /= max(1, (times.length - 1));
      _avgtime /= 1e3;
      _avgtime *= 1000;
      _avgtime = _avgtime.round() / 1000;
      _counter++;
      _x = randx.nextDouble() * 100;
      _y = randy.nextDouble() * 100;
      stopwatch.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    const double sizse = 64;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              //
              // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
              // action in the IDE, or press "p" in the console), to see the
              // wireframe for each widget.
              mainAxisAlignment: .center,
              children: [
                Text(widget.username+' whacked a Mole this many times:'),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Text("Avg time taken:"),
                Text(
                  '$_avgtime' + 's',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          Positioned(
            child: SizedBox(
              height: sizse,
              width: sizse,
              child: GestureDetector(
                onTap: _incrementCounter,
                child: Image.asset("assets/mole.png"),
              ),
            ),
            left: ((MediaQuery.of(context).size.width * _x / 100) - (sizse / 2))
                .clamp(0.0, (MediaQuery.of(context).size.width - (sizse))),
            top: ((MediaQuery.of(context).size.height * _y / 100) - (sizse / 2))
                .clamp(0.0, (MediaQuery.of(context).size.height - (sizse))),
          ),
        ],
      ),
    );
  }
}
