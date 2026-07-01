import 'package:equatable/equatable.dart';

enum ExpenseCategory { food, transport, bills, other }

extension ExpenseCategoryX on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.bills:
        return 'Bills';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  static ExpenseCategory fromLabel(String? value) {
    if (value == null) return ExpenseCategory.other;
    return ExpenseCategory.values.firstWhere(
      (c) => c.label.toLowerCase() == value.toLowerCase(),
      orElse: () => ExpenseCategory.other,
    );
  }
}

class Expense extends Equatable {
  final String id;
  final String title;
  final int amountKobo;
  final ExpenseCategory category;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.title,
    required this.amountKobo,
    required this.category,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      amountKobo: json['amountKobo'] as int,
      category: ExpenseCategoryX.fromLabel(json['category'] as String?),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Used for POST — id and createdAt are server-assigned, so they're
  /// deliberately excluded here.
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'amountKobo': amountKobo,
      'category': category.label,
    };
  }

  @override
  List<Object?> get props => [id, title, amountKobo, category, createdAt];
}
