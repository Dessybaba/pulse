import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pulse/theme/app_colors.dart';
import '../core/utils/currency_formatter.dart';
import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;

  const ExpenseTile({super.key, required this.expense, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat(
      'MMM d, y',
    ).format(expense.createdAt.toLocal());

    final categoryColor = AppColors.categoryColor(expense.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 4, color: categoryColor),
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onTap: onTap,
                title: Text(
                  expense.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('${expense.category.label} • $dateLabel'),
                trailing: Text(
                  CurrencyFormatter.fromKobo(expense.amountKobo),
                  style: GoogleFonts.ibmPlexMono(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
