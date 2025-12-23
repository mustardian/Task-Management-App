import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/tasks/presentation/screens/task_list_screen.dart';
import '../../features/tasks/presentation/screens/add_edit_task_screen.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.asData?.value != null;
      final isLoggingIn = state.uri.toString() == '/login';
      final isSigningUp = state.uri.toString() == '/signup';

      if (!isLoggedIn && !isLoggingIn && !isSigningUp) {
        return '/login';
      }

      if (isLoggedIn && (isLoggingIn || isSigningUp)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const TaskListScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/add-task',
        builder: (context, state) => const AddEditTaskScreen(),
      ),
      GoRoute(
        path: '/edit-task',
        builder: (context, state) {
           // We will pass the task object via extra
           // import logic will be handled in the screen
           return const AddEditTaskScreen();
        },
      ),
    ],
  );
});
