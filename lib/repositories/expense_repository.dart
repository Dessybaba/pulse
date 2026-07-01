import 'package:dio/dio.dart';
import '../core/errors/failures.dart';
import '../models/expense.dart';
import '../services/expense_api_service.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<Expense> addExpense({
    required String title,
    required int amountKobo,
    required String category,
  });
  Future<void> deleteExpense(String id);
}

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseApiService _apiService;

  ExpenseRepositoryImpl(this._apiService);

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      return await _apiService.fetchExpenses();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<Expense> addExpense({
    required String title,
    required int amountKobo,
    required String category,
  }) async {
    try {
      return await _apiService.createExpense(
        title: title,
        amountKobo: amountKobo,
        category: category,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await _apiService.deleteExpense(id);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Failure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const TimeoutFailure();
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }

    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 400:
        final msg = e.response?.data?['error'] as String? ?? 'Invalid request.';
        return ValidationFailure(msg);
      case 404:
        return const NotFoundFailure();
      case 500:
        return const ServerFailure();
      default:
        return const UnknownFailure();
    }
  }
}
