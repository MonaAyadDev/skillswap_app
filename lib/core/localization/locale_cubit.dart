import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  void setLocale(Locale locale) {
    if (state.languageCode != locale.languageCode) {
      emit(locale);
    }
  }

  void toggleLanguage() {
    if (state.languageCode == 'ar') {
      emit(const Locale('en'));
    } else {
      emit(const Locale('ar'));
    }
  }

  void setArabic() => emit(const Locale('ar'));
  void setEnglish() => emit(const Locale('en'));

  bool get isArabic => state.languageCode == 'ar';
}
