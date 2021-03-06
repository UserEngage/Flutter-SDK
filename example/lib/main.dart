import 'dart:math';

import 'package:example/test_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/flutter_user_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SDK and pass arguments.
  // Find your keys on https://user.com/pl/
  // NOTE: ADD google-services.json file to run app.
  await UserComSDK.instance.initialize(
    mobileSdkKey: '',
    appDomain: '',
  );

  runApp(const UserComApp());
}

class UserComApp extends StatelessWidget {
  const UserComApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        // Send screen events when entering new page
        // If using custom routing, make Your own observer and
        // use UserSDK.instance.sendScreenEvent()
        // Dont forget to name Routes in settings
        UserSdkNavigatorObserver(),
      ],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _sendCustomEvent() {
    // Send event with data that can be converted to simple types
    UserComSDK.instance.sendCustomEvent(
      eventName: 'user_interacted',
      data: <String, dynamic>{
        'button_id': Random.secure().nextInt(999),
      },
    );
  }

  void _sendCustomEventWithLargePayload() {
    // Send event with nested json
    UserComSDK.instance.sendCustomEvent(
      eventName: 'user_interacted',
      data: testNestedPayloadData,
    );
  }

  void _sendProductEvent() {
    // Define your own product parameters and send product event
    UserComSDK.instance.sendProductEvent(
      event: ProductEvent(
        productId: Random().nextInt(9999).toString(),
        eventType: ProductEventType.addToCart,
        parameters: <String, dynamic>{
          'price': Random().nextDouble(),
          'ref_number': '222',
          'time_spent_in_mins': Random().nextInt(999),
          'converted': true,
          'variant_id': 'qaz123'
        },
      ),
    );
  }

  void _registerUser() {
    // Send more informaton about user. You can add custom attributes.
    // Attributes must be simple type.
    UserComSDK.instance.registerUser(
      customer: Customer(
        userId: 'my_own_id_2',
        email: 'my_own_user@gmail.com',
        firstName: 'Test',
        lastName: 'User',
      )
        ..addCustomAttribute('country', 'USA')
        ..addCustomAttribute('has_benefits', true)
        ..addCustomAttribute('sex', 'female')
        ..addCustomAttribute('age', 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserComSDK.instance.buildNotificationOnMessageReceived(context: context);

    return Scaffold(
      appBar: AppBar(title: const Text('User SDK Exapmle App')),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Pushing new page triggers screen_event
                // Observer must be attached and routes must be named
                Navigator.of(context).push(
                  MaterialPageRoute(
                    settings: const RouteSettings(name: 'ProductPage'),
                    builder: (_) => Scaffold(
                      body: Container(
                        alignment: Alignment.center,
                        child: const Text('ProductPage'),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Go to Product Page'),
            ),
            // Sending event and binding it to user
            ElevatedButton(
              onPressed: () => _sendCustomEvent(),
              child: const Text('Send custom event'),
            ),
            ElevatedButton(
              onPressed: () => _sendCustomEventWithLargePayload(),
              child: const Text('Send large payload event'),
            ),
            // Sending product event and binding it to user
            ElevatedButton(
              onPressed: () => _sendProductEvent(),
              child: const Text('Send product event'),
            ),
            // Add custom info to current anonymus user
            ElevatedButton(
              onPressed: () => _registerUser(),
              child: const Text('Register user'),
            ),
            // Destroys reference to user and clear all cache.
            // It also destroy reference to anonymus User and a new one will be created.
            ElevatedButton(
              onPressed: () => UserComSDK.instance.logoutUser(),
              child: const Text('Logout user'),
            ),
          ],
        ),
      ),
    );
  }
}
