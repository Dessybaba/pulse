import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/expense.dart';
import '../../providers/expense_providers.dart';

class ExpenseDetailScreen extends ConsumerStatefulWidget {
  final Expense expense;

  const ExpenseDetailScreen({super.key, required this.expense});

  @override
  ConsumerState<ExpenseDetailScreen> createState() =>
      _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends ConsumerState<ExpenseDetailScreen> {
  bool _isDeleting = false;

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense?'),
        content: Text(
          'This will permanently delete "${widget.expense.title}".',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);
    try {
      await ref
          .read(expenseListProvider.notifier)
          .deleteExpense(widget.expense.id);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _isDeleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final expense = widget.expense;
    final dateLabel = DateFormat(
      'MMM d, y • h:mm a',
    ).format(expense.createdAt.toLocal());

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              CurrencyFormatter.fromKobo(expense.amountKobo),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _DetailRow(label: 'Category', value: expense.category.label),
            _DetailRow(label: 'Date', value: dateLabel),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isDeleting ? null : _confirmDelete,
                icon: const Icon(Icons.delete_outline),
                label: Text(_isDeleting ? 'Deleting...' : 'Delete Expense'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
