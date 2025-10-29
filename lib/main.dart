import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/home_page.dart';
import 'pages/scan_page.dart';
import 'pages/result_page.dart';
import 'pages/history_page.dart';
import 'stores/history_store.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HistoryStore.init();
  runApp(const ProviderScope(child: MediLensApp()));
}


class MediLensApp extends StatelessWidget {
  const MediLensApp({super.key});


  @override
  Widget build(BuildContext context) {
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (_, __) => const HomePage()),
      GoRoute(path: '/scan', builder: (_, __) => const ScanPage()),
      GoRoute(path: '/result', builder: (ctx, st) => ResultPage(map: st.extra as Map<String, dynamic>)),
      GoRoute(path: '/history', builder: (_, __) => const HistoryPage()),
    ]);




    return MaterialApp.router(
      title: 'animallens',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
        textTheme: Typography.blackCupertino, // crisper text
      ),

      routerConfig: router,
    );
  }
}

