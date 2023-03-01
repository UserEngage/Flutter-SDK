# User.com Flutter SDK (flutter_user_sdk)

User.com package helps developers track user activities inside the app. Flutter 2 & Flutter 3 versions are supported.

## Features

- Sending custom events
- Sending product events
- Sending screen events
- Sending notification events
- Registering and saving user data
- Receiving FCM notifications  (in-app notifications and mobile notifications)
- Caching unsent requests due to no connection 
- Resending request when connection is available 

# Warning
We are in proccess of migration from displaying notifications via flutter_local_notifications to native Firebase Messaging. Currently our plaftom do not support this and package will need additional steps to integrate which is described in Project Integration. We hope to migrate as soon as possible and make flutter_user_sdk simplier to integrate :)

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

## Project Integration

#### IOS - AppDelegate.swift

    import UIKit
    import Flutter
    import flutter_local_notifications

    @UIApplicationMain
    @objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // This is required to make any communication available in the action isolate.
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }

        if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
    



#### Android

Android uses flutter_local_notifications to display native notifications. Follow steps to add support for this library in Your project:  

##### 1. Add your notification.png icon that will be displayed in notification. Place it under android/src/main/res/drawable folder.

##### 2. Version 10+ on the plugin now relies on desugaring to support scheduled notifications with backwards compatibility on older versions of Android. Developers will need to update their application's Gradle file at android/app/build.gradle. Please see the link on desugaring for details but the main parts needed in this Gradle file would be

    android {
        defaultConfig {
            multiDexEnabled true
        }

        compileOptions {
            // Flag to enable support for the new language APIs
            coreLibraryDesugaringEnabled true
            // Sets Java compatibility to Java 8
            sourceCompatibility JavaVersion.VERSION_1_8
            targetCompatibility JavaVersion.VERSION_1_8
        }
    }

    dependencies {
        coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.1.5'
    }


#### Lib also requires

    android {
        compileSdkVersion 33
        ...
    }

#### Note
There have been reports that enabling desugaring may result in a Flutter apps crashing on Android 12L and above. This would be an issue with Flutter itself, not the plugin. One possible fix is adding the WindowManager library as a dependency:

    dependencies {
        implementation 'androidx.window:window:1.0.0'
        implementation 'androidx.window:window-java:1.0.0'
        ...
    }
###### For more informations visit https://user.com/en/mobile-sdk/ and check detailed documentation.


## Usage 
Example how to use methods provided in SDK:
~~~
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SDK and pass arguments.
  // Find your keys on https://user.com/en/
  await UserComSDK.instance.initialize(
    mobileSdkKey: [YOUR_KEY_FROM_USER_COM],
    appDomain: [URL_FROM_USER_COM], // 'https://testapp.user.com/',
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
        // If using custom routing, make your own observer and
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
    // Send more informaton about the user. You can add custom attributes.
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
            // Add custom info to current anonymous user
            ElevatedButton(
              onPressed: () => _registerUser(),
              child: const Text('Register user'),
            ),
            // Destroys reference to user and clear all cache.
            // It also destroys reference to anonymous user and a new one will be created.
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
~~~

## License

MIT
