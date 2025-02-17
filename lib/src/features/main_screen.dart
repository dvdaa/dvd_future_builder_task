import 'dart:math';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _textEditingController = TextEditingController();
  Future<String>? _postalCodeSearchResult;

  @override
  void initState() {
    super.initState();
    // TODO: initiate controllers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Postleitzahl"),
                ),
                const SizedBox(height: 32),
                OutlinedButton(
                  onPressed: () {
                    setState(
                      () {
                        _postalCodeSearchResult =
                            getCityFromZip(_textEditingController.text);
                      },
                    );
                  },
                  child: const Text("Suche"),
                ),
                const SizedBox(height: 32),
                FutureBuilder(
                  future: _postalCodeSearchResult,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Text(
                          "${snapshot.data}",
                          style: Theme.of(context).textTheme.labelLarge,
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          "Suche fehlgeschlagen",
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.red),
                        );
                      }
                    }
                    return Text(
                      "Ergebnis: Noch nicht gesucht...",
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<String> getCityFromZip(String zip) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(milliseconds: 500));

    if (Random().nextInt(5) == 0) {
      throw Exception("Ooopsie...");
    }

    switch (zip) {
      case "10115":
        return 'Berlin';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      default:
        return 'Unbekannte Stadt';
    }
  }
}
