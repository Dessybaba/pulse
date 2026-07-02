import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/errors/failures.dart';
import 'package:pulse/providers/theme_provider.dart';
import 'package:pulse/widgets/pulse_line.dart';
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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulse'),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
            tooltip: 'Toggle theme',
          ),
        ],
      ),
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
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total spent',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          CurrencyFormatter.fromKobo(totalKobo),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    PulseLine(
                      color: Theme.of(context).colorScheme.primary,
                      height: 28,
                      animate: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: expensesAsync.when(
              loading: () => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: PulseLine(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
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
                      return TweenAnimationBuilder<double>(
                        duration: Duration(
                          milliseconds: 300 + (index * 40).clamp(0, 400),
                        ),
                        tween: Tween(begin: 0, end: 1),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, (1 - value) * 12),
                              child: child,
                            ),
                          );
                        },
                        child: ExpenseTile(
                          expense: expense,
                          onTap: () => context.push('/expense', extra: expense),
                        ),
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
