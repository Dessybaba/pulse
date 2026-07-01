import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/expense.dart';
import '../../providers/expense_providers.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory? _category;
  bool _isSaving = false;
  String? _submitError;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate() || _category == null) {
      if (_category == null) {
        setState(() => _submitError = 'Please select a category.');
      }
      return;
    }

    setState(() {
      _isSaving = true;
      _submitError = null;
    });

    final naira = double.parse(_amountController.text.trim());
    final amountKobo = (naira * 100).round();

    try {
      await ref
          .read(expenseListProvider.notifier)
          .addExpense(
            title: _titleController.text.trim(),
            amountKobo: amountKobo,
            category: _category!.label,
          );
      if (mounted) context.pop();
    } catch (e) {
      setState(() {
        _submitError = e is Exception
            ? e.toString()
            : 'Failed to save expense. Please try again.';
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount (NGN)'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Amount is required';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Enter a positive amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ExpenseCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: ExpenseCategory.values
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                  .toList(),
              onChanged: (value) => setState(() => _category = value),
            ),
            if (_submitError != null) ...[
              const SizedBox(height: 12),
              Text(_submitError!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _onSave,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
