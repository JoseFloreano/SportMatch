import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/providers/supabase_provider.dart';

part 'rating_provider.g.dart';

/// True si todavía no he calificado esa sesión.
@riverpod
Future<bool> hasPendingRating(Ref ref, String sessionId) {
  return ref.watch(ratingRepositoryProvider).hasPendingRating(sessionId);
}

/// Maneja el envío de calificaciones post-sesión (Sprint 2).
@riverpod
class RatingController extends _$RatingController {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({
    String? sessionId,
    String? eventId,
    required String ratedId,
    required int punctuality,
    required int levelAccuracy,
    required int respect,
    String? comment,
  }) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(
      () => ref.read(ratingRepositoryProvider).rateUser(
            sessionId: sessionId,
            eventId: eventId,
            ratedId: ratedId,
            punctuality: punctuality,
            levelAccuracy: levelAccuracy,
            respect: respect,
            comment: comment,
          ),
    );
    state = res;
    return !res.hasError;
  }
}
