import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rick_and_morty_app/data/models/card_model.dart';
import 'package:rick_and_morty_app/data/models/card_model_adapter.dart';
import 'package:rick_and_morty_app/presentation/main_page.dart';
import 'package:rick_and_morty_app/presentation/pages/favorites/favorites_bloc.dart';
import 'package:rick_and_morty_app/presentation/pages/favorites/favorites_event.dart';
import 'package:rick_and_morty_app/presentation/pages/home/home_bloc.dart';
import 'package:rick_and_morty_app/presentation/pages/home/home_event.dart';
import 'data/api_client.dart';
import 'data/card_repository.dart';
import 'presentation/pages/home/home_page.dart';
import 'core/theme/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CardModelAdapter());
  final box = await Hive.openBox<CardModel>('cards');
  final settingsBox = await Hive.openBox('settings');

  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10)
  ))
  ..interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true
  ));

  final apiClient = ApiClient(dio);
  final repository = CardRepository(apiClient: apiClient, box: box);
  //final repository = CardRepository(apiClient: apiClient);

  //runApp(MyApp(repository: repository));
  runApp(
    MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => CardRepository(apiClient: apiClient, box: box))], 
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(repository)
          ),
          BlocProvider(create: (context) => FavoritesBloc(repository)..add(LoadFavorites())),
          BlocProvider(create: (context) => ThemeCubit(settingsBox))
        ], 
        child: const MyApp()
      )
    )
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Rick and Morty App',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.lightBlue,
            brightness: Brightness.light,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black
            )
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.lightBlue,
            brightness: Brightness.dark,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white
            )
          ),
          themeMode: themeMode,
          home: const MainPage()
        );
      }
    );
  }
}
