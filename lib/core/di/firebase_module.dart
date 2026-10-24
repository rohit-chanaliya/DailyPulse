import 'package:inject_annotation/inject_annotation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Provides Firebase singletons to the dependency graph.
@module
class FirebaseModule {
  @provides
  @singleton
  FirebaseAuth provideAuth() => FirebaseAuth.instance;

  @provides
  @singleton
  FirebaseFirestore provideFirestore() => FirebaseFirestore.instance;
}
