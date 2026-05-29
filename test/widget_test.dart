// Tests unitarios básicos de SportMatch.
// Un widget test de la app completa requeriría Supabase.initialize(), por eso
// aquí probamos lógica pura que no depende del backend.

import 'package:flutter_test/flutter_test.dart';
import 'package:sportmatch/core/constants/app_constants.dart';
import 'package:sportmatch/data/models/rating_model.dart';

void main() {
  group('AppConstants.formatMxPhone', () {
    test('agrega lada internacional a un número de 10 dígitos', () {
      expect(AppConstants.formatMxPhone('5512345678'), '5215512345678');
    });

    test('respeta números que ya empiezan con 52', () {
      expect(AppConstants.formatMxPhone('525512345678'), '525512345678');
    });

    test('limpia separadores', () {
      expect(AppConstants.formatMxPhone('55 1234 5678'), '5215512345678');
    });
  });

  group('AppConstants.sportEmoji', () {
    test('devuelve el emoji correcto', () {
      expect(AppConstants.sportEmoji('crossfit'), '🏋️');
    });

    test('usa fallback para deporte desconocido', () {
      expect(AppConstants.sportEmoji('desconocido'), '🏃');
    });
  });

  group('RatingModel.computeOverall', () {
    test('promedia los tres criterios', () {
      expect(RatingModel.computeOverall(5, 4, 3), 4.0);
    });
  });
}
