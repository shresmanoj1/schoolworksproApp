import 'package:flutter/material.dart';

class NoInternetWidget extends StatefulWidget {
  const NoInternetWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 30,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 15),
            ),
            const Text(
              'Please connect to the internet and try again',
              style: TextStyle(fontSize: 12),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/');
                    },
                    icon: Icon(Icons.refresh),
                    label: Text("Refresh")))
          ],
        ),
      ),
    );
  }
}
