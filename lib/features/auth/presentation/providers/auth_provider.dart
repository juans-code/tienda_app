import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) async* {
  // ⏱️ TRUCO TEMPORAL: Forzamos una espera de 3 segundos antes de escuchar a Firebase
  await Future.delayed(const Duration(seconds: 3));
  
  // Una vez pasan los 3 segundos, emitimos el flujo real de Firebase
  yield* FirebaseAuth.instance.authStateChanges();
});