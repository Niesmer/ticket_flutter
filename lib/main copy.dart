import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ticket_flutter/Views/HomeView.dart';
import 'package:ticket_flutter/Views/LoginView.dart';
import 'package:ticket_flutter/Views/ProfileView.dart';
import 'package:ticket_flutter/components/events/eventListPage.dart';
import 'package:ticket_flutter/global.dart';
import 'package:ticket_flutter/layout_scaffold.dart';
import 'package:ticket_flutter/model/destination.dart';
import 'package:ticket_flutter/supabase.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SupaConnect();
  currentUser = await SupaConnect().getUser();

  setUrlStrategy(PathUrlStrategy()); // Configure to use path-based URLs
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    SupaConnect().client.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      switch (event) {
        case AuthChangeEvent.signedIn:
          print('signedIn');
          currentUser = await SupaConnect().getUser();
          _isLoggedIn.value = true;
          break;
        case AuthChangeEvent.signedOut:
          print('signedOut');
          currentUser = null;
          _isLoggedIn.value = false;
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoggedIn,
      builder: (context, isLoggedIn, child) {
        if (!isLoggedIn) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: LoginView(),
          );
        }

        final dest = currentUser?.isAdmin == true ? destinationsAdmin : destinations;

        List<StatefulShellBranch> createBranches() {
          return dest.map((destination) {
            return StatefulShellBranch(routes: [
              GoRoute(
                path: destination.label == 'Acceuil'
                    ? '/'
                    : '/${destination.label.replaceAll(' ', '').toLowerCase()}',
                builder: (context, state) {
                  switch (destination.label) {
                    case 'Acceuil':
                      return HomeView();
                    case 'Profil':
                      return ProfileView();
                    case 'Admin Event':
                      return EventListPage();
                    default:
                      return HomeView();
                  }
                },
              ),
            ]);
          }).toList();
        }

        final GoRouter router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => LoginView(),
            ),
            StatefulShellRoute.indexedStack(
                builder: (context, state, navigationShell) => LayoutScaffold(
                      navigationShell: navigationShell,
                      dest: dest,
                    ),
                branches: createBranches())
          ],
          redirect: (context, state) async {
            final loggingIn = state.uri.toString() == '/login';

            // Redirect unauthenticated users to the login page
            if (currentUser == null && !loggingIn) {
              return '/login';
            }

            // Prevent authenticated users from accessing the login page
            if (currentUser != null && loggingIn) {
              return '/';
            }

            // Check if the user has admin privileges before accessing the AdminEvent page
            if (state.uri.toString() == '/AdminEvent' &&
                (currentUser == null || !currentUser!.isAdmin)) {
              return '/';
            }

            return null;
          },
        );

        return MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
