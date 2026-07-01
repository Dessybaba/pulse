import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../models/expense.dart';

class ExpenseApiService {
  final Dio _dio;

  ExpenseApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              connectTimeout: ApiConstants.connectTimeout,
              receiveTimeout: ApiConstants.receiveTimeout,
            ),
          );

  Future<List<Expense>> fetchExpenses() async {
    final response = await _dio.get('');
    final data = response.data as Map<String, dynamic>;
    final list = data['expenses'] as List<dynamic>;
    return list
        .map((json) => Expense.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Expense> createExpense({
    required String title,
    required int amountKobo,
    required String category,
  }) async {
    final response = await _dio.post(
      '',
      data: {'title': title, 'amountKobo': amountKobo, 'category': category},
    );
    return Expense.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteExpense(String id) async {
    await _dio.delete('/$id');
  }
}
