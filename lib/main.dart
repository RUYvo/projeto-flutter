import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/app.dart';
import 'package:food_app/screens/cart/blocs/bloc/cart_bloc.dart';
import 'package:food_app/simple_bloc_observer.dart';
import 'package:user_repository/user_repository.dart';
import 'package:food_repository/food_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = SimpleBlocObserver();

  runApp(
    MultiProvider(
      providers: [
        Provider<UserRepository>(
          create: (context) => FirebaseUserRepo(),
        ),
        Provider<FirebaseFoodRepo>(
          create: (context) => FirebaseFoodRepo(),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(
            context.read<UserRepository>(),
            context.read<FirebaseFoodRepo>(),
          ),
        ),
      ],
      child: MyApp(FirebaseUserRepo()), 
    ),
  );
}
