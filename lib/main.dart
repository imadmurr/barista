import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/config/app_router.dart';
import 'core/config/theme.dart';
import 'data/auth_repository.dart';
import 'data/favorites_repository.dart';
import 'state/auth_controller.dart';
import 'state/favorites_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CocktailStudioApp());
}

class CocktailStudioApp extends StatelessWidget {
  const CocktailStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => AuthRepository.instance),
        ChangeNotifierProvider<AuthController>(
          create: (ctx) => AuthController(ctx.read<AuthRepository>()),
        ),

        Provider<FavoritesRepository>(
          create: (_) => FavoritesRepository.instance,
        ),
        ChangeNotifierProvider<FavoritesController>(
          create: (ctx) => FavoritesController(
            ctx.read<AuthController>(),
            ctx.read<FavoritesRepository>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final auth = context.watch<AuthController>();
          final router = createRouter(auth);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Cocktail Studio Prototype',
            theme: AppTheme.darkTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
