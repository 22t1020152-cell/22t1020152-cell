import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_product2.dart';
import 'models/product.dart';
import 'trangchu.dart';
import 'login_page.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => AuthProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product demo (web)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Consumer<AuthProvider>(
        builder: (ctx, authProvider, _) {
          // Auth gate: if not authenticated, show login; otherwise show trang chủ
          if (!authProvider.isAuthenticated) {
            return LoginPage(
              onLoginSuccess: (accessToken, refreshToken) async {
                await authProvider.login(accessToken, refreshToken);
              },
            );
          }
          return const AuthGatedApp();
        },
      ),
    );
  }
}

/// AuthGatedApp: Only accessible to authenticated users.
class AuthGatedApp extends StatelessWidget {
  const AuthGatedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {'/': (ctx) => const TrangChuPage()},
      onGenerateRoute: (settings) {
        if (settings.name == '/product') {
          final product = settings.arguments as Product;
          return MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          );
        }
        return null;
      },
    );
  }
}
