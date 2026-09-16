import 'package:flutter_bloc/flutter_bloc.dart';

/// Tracks the app-wide dark-mode toggle (the design's `darkMode` state,
/// switched from the home screen's sun/moon button).
class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);

  void toggle() => emit(!state);
}
