import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_care/providers/message_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '/providers/main_provider.dart';
import '/providers/translation_provider.dart';
import '/screens/catalog/article_detail_screen.dart';
import '/screens/catalog/articles.dart';
import '/screens/catalog/catalog_screen.dart';
import '/screens/catalog/constant_infos.dart';
import '/screens/info/info_screen.dart';
import '/screens/map_screen.dart';
import '/screens/profile/editing_profile.dart';
import '/screens/profile/profil_screen.dart';
import './style/main_style.dart';
import 'auth/firebase_options.dart';
import 'screens/info/info_detail.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainRoute());
}

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});
  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainProvider()),
        ChangeNotifierProvider(create: (context) => MainProviderUz()),
        ChangeNotifierProvider(create: (context) => MapProvider()),
        ChangeNotifierProvider(create: (context) => InfoProvider()),
        ChangeNotifierProvider(create: (context) => InfoProviderUz()),
        ChangeNotifierProvider(create: (context) => Translate()),
        ChangeNotifierProvider(create: (context) => DriverLocationProvider()),
        ChangeNotifierProvider(create: (context) => MessagesProvider()),
        ChangeNotifierProvider(create: (context) => ProfilScreen()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: theme,
        routerConfig: GoRouter(routes: [
          GoRoute(
            path: '/',
            name: HomeScreen.routeName,
            builder: (context, state) => HomeScreen(),
            routes: [
              GoRoute(
                path: 'catalog',
                name: CatalogScreen.routeName,
                builder: (context, state) => CatalogScreen(),
                routes: [
                  GoRoute(
                      path: 'articles',
                      name: Articles.routeName,
                      builder: (context, state) => Articles(
                            name: (state.extra as Map<String, Object>)['name'].toString(),
                            index: int.parse((state.extra as Map<String, Object>)['index'].toString()),
                          ),
                      routes: [
                        GoRoute(
                          path: 'article-detail',
                          name: ArticleDetailScreen.routeName,
                          builder: (context, state) => ArticleDetailScreen(
                            name: (state.extra as Map<String, Object>)['name'].toString(),
                            indx: int.parse((state.extra as Map<String, Object>)['index'].toString()),
                          ),
                        ),
                      ])
                ],
              ),
              GoRoute(
                path: 'info',
                name: InfoScreen.routeName,
                builder: (context, state) => InfoScreen(),
                routes: [
                  GoRoute(
                    path: 'info-detail',
                    name: InfoDetail.routeName,
                    builder: (context, state) => const InfoDetail(),
                  ),
                ],
              ),
              GoRoute(
                path: 'profile',
                name: ProfilScreen.routeName,
                builder: (context, state) => ProfilScreen(
                  image: state.extra != null ? state.extra as File : null,
                ),
                routes: [
                  GoRoute(
                    path: 'editing',
                    name: EditingProfile.routeName,
                    builder: (context, state) => EditingProfile(
                      image: state.extra != null ? state.extra as File : null,
                    ),
                  ),
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }
}
