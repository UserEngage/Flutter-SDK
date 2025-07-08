# User.com Flutter SDK (flutter_user_sdk)

User.com package helps developers track user activities inside the app.

## Features

- Displaying FCM notifications  (in-app notifications and mobile notifications)
- Sending notification events and statistics
- Registering and saving user data
- Sending analytics events - product, screen, custom types
- Caching unsent requests due to no connection 
- Resending request when connection is available

## Installation

Add the newest version of a package to your project using:


    flutter pub add flutter_user_sdk

## Getting started

#### To start using flutter_user_sdk package follow this steps:

###### 1.  Go to User.com and create or login into your app.
###### 2.  Get required variables to initialize SDK - mobileSdkKey and appDomain
-   App domain is a URL on which an app is running
-  To get mobileSdkKey - go to the Settings -> App settings -> Advanced -> Mobile SDK keys
###### 3. SDK uses FCM so Firebase project is required to run the package properly.
-  Go to Firebase and create projects for Android and iOS
-  Download google-services.json and GoogleServices-Info.plist files and add it to project
-  Create .p8 APN key in App Store Connect and paste it into Firebase Project
-  Find server key in the Firebase Project - go to the Settings -> Cloud Messaging
-  Paste server key in User.com app: Settings -> App settings -> Advanced -> Mobile FCM keys

### 🚨 Note

Firebase Messaging is not integrated directly into the package to allow developers full control over message handling logic, including support for custom backends, multiple message sources, or environment-specific configurations (e.g., via flavors).

## Usage 
Example how to use methods provided in SDK:
~~~
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final token = await FirebaseMessaging.instance.getToken();

  // Find your keys on https://user.com/pl/
  // If You want to receive notifications from User.com, you must provide FCM token
  // Otherwise You can use SDK only for sending events and registering users.
  await UserComSDK.instance.initialize(
    mobileSdkKey: 'paste_your_key_from_user_com',
    appDomain: 'app_domain_is_base_url',
    fcmToken: token,
  );

  runApp(const UserComApp());
}

class UserComApp extends StatefulWidget {
  const UserComApp({Key? key}) : super(key: key);

  @override
  State<UserComApp> createState() => _UserComAppState();
}

class _UserComAppState extends State<UserComApp> {
  @override
  void initState() {
    // flutter_user_sdk is not initialising FirebaseMessaging by itself to allow
    // more flexibility in handling other messages that are not related to User.com.
    // Thats why in this example we create a simple service that will listen for messages
    FirebaseSimpleService().initialize(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        // Send screen event when pushing new page to navigator
        // Create your own observer and use [UserComSDK.instance.sendScreenEvent]
        // if custom bahaviour is needed
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
    // Send events with large nested jsons
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
    UserComSDK.instance.registerUser(
      customer: Customer(
        userId: 'my_own_id_3',
        email: 'my_own_user@gmail.com',
        gender: 2,
        firstName: 'Test',
        lastName: 'User',
        phoneNumber: '+1234567890',
        score: 100,
        unsubscribed: true,
      )
        ..addCustomAttribute('country', 'USA')
        ..addCustomAttribute('has_benefits', true)
        ..addCustomAttribute('nick', 'freddy')
        ..addCustomAttribute('age', 22),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
              onPressed: () => _sendCustomEvent(),
              child: const Text('Send custom event'),
            ),
            ElevatedButton(
              onPressed: () => _sendCustomEventWithLargePayload(),
              child: const Text('Send large payload event'),
            ),
            ElevatedButton(
              onPressed: () => _sendProductEvent(),
              child: const Text('Send product event'),
            ),
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

// Simplified service for handling User.com messages that are pushed via FirebaseMessaging.
// Remember to fetch FCM token and pass it to [UserSDK.instance.initialize()].
class FirebaseSimpleService {
  FirebaseSimpleService._();

  factory FirebaseSimpleService() {
    return _instance;
  }

  static final FirebaseSimpleService _instance = FirebaseSimpleService._();

  // Init all Firebase methods
  void initialize(BuildContext context) {
    onInitialMessage();
    onMessageOpenedApp();
    onMessage(context);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  }

  void onInitialMessage() async {
    final remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage == null) return;

    if (UserComSDK.instance.isUserComMessage(remoteMessage.data)) {
      final message = UserComSDK.instance.getPushMessage(remoteMessage.data);

      if (message != null) {
        UserComSDK.instance.notificationClickedEvent(
          id: message.id,
          type: message.type,
        );

        // process with User.com Push Message
      }
    }

    // process other Firebase Messages
  }

  void onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        if (UserComSDK.instance.isUserComMessage(event.data)) {
          final message = UserComSDK.instance.getPushMessage(event.data);

          if (message != null) {
            UserComSDK.instance.notificationClickedEvent(
              id: message.id,
              type: message.type,
            );
            // process with User.com Push Message
          }
        }
      },

      // process other Firebase Messages
    );
  }

  void onMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen(
      (event) {
        if (UserComSDK.instance.isUserComMessage(event.data)) {
          // Displaying messages in [buildNotificationOnMessageReceived]
          // can be customized using [inAppMessageBuilder] and [pushMessageBuilder]
          UserComSDK.instance.buildNotificationOnMessageReceived(
            context: context,
            message: event,
            onTap: (type, link) {
              if (type == NotificationType.push) {
                // Define here what to do on notification tap
                // For example launchUrl and dismiss notification
              }
              if (type == NotificationType.inApp) {
                // Define here what to do when user tap button that has link
              }
            },
          );
        }

        // ... Process on other messages coming from FCM
      },
    );
  }
}

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {}


## License

MIT
