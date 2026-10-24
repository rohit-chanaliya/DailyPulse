import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:inject_annotation/inject_annotation.dart';

/// Provides platform infrastructure singletons to the dependency graph.
@module
class InfrastructureModule {
  @provides
  @singleton
  Connectivity provideConnectivity() => Connectivity();
}
