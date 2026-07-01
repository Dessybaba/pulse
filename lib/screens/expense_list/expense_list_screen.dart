import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/errors/failures.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/expense_providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/expense_tile.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListProvider);
    final totalKobo = ref.watch(totalExpensesKoboProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pulse')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total spent',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      CurrencyFormatter.fromKobo(totalKobo),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: expensesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => ErrorState(
                message: err is Failure
                    ? err.message
                    : 'Something went wrong. Please try again.',
                onRetry: () => ref.read(expenseListProvider.notifier).refresh(),
              ),
              data: (expenses) {
                if (expenses.isEmpty) return const EmptyState();
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(expenseListProvider.notifier).refresh(),
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return ExpenseTile(
                        expense: expense,
                        onTap: () => context.push('/expense', extra: expense),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
