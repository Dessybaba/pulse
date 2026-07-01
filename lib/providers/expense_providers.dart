import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../repositories/expense_repository.dart';
import '../services/expense_api_service.dart';

final expenseApiServiceProvider = Provider<ExpenseApiService>((ref) {
  return ExpenseApiService();
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(ref.watch(expenseApiServiceProvider));
});

class ExpenseListNotifier extends AsyncNotifier<List<Expense>> {
  @override
  Future<List<Expense>> build() async {
    final repo = ref.watch(expenseRepositoryProvider);
    return repo.getExpenses();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(expenseRepositoryProvider).getExpenses(),
    );
  }

  Future<void> addExpense({
    required String title,
    required int amountKobo,
    required String category,
  }) async {
    final repo = ref.read(expenseRepositoryProvider);
    final newExpense = await repo.addExpense(
      title: title,
      amountKobo: amountKobo,
      category: category,
    );
    // Optimistic local update — no GET refetch, per the brief.
    final current = state.valueOrNull ?? [];
    state = AsyncData([newExpense, ...current]);
  }

  Future<void> deleteExpense(String id) async {
    final repo = ref.read(expenseRepositoryProvider);
    final current = state.valueOrNull ?? [];
    // Optimistic removal, with rollback on failure.
    state = AsyncData(current.where((e) => e.id != id).toList());
    try {
      await repo.deleteExpense(id);
    } catch (e) {
      state = AsyncData(current); // rollback
      rethrow;
    }
  }
}

final expenseListProvider =
    AsyncNotifierProvider<ExpenseListNotifier, List<Expense>>(
      ExpenseListNotifier.new,
    );

final totalExpensesKoboProvider = Provider<int>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  return expenses.fold(0, (sum, e) => sum + e.amountKobo);
});
