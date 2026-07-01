import 'package:go_router/go_router.dart';
import '../models/expense.dart';
import '../screens/expense_list/expense_list_screen.dart';
import '../screens/add_expense/add_expense_screen.dart';
import '../screens/expense_detail/expense_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ExpenseListScreen()),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddExpenseScreen(),
    ),
    GoRoute(
      path: '/expense',
      builder: (context, state) {
        final expense = state.extra as Expense;
        return ExpenseDetailScreen(expense: expense);
      },
    ),
  ],
);
