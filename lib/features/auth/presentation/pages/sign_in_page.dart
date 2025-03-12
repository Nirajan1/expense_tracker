import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/core/app_loading_card.dart';
import 'package:expense_tracker/core/app_snack_bar.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/pages/sign_up_page.dart';
import 'package:expense_tracker/features/bottom_navigation/presentation/pages/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPageView extends StatefulWidget {
  const SignInPageView({super.key});

  @override
  State<SignInPageView> createState() => _SignInPageViewState();
}

class _SignInPageViewState extends State<SignInPageView> {
  final TextEditingController loginUserNameController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  @override
  void dispose() {
    loginUserNameController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72),
                Text(
                  'Welcome',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: const Color.fromARGB(255, 20, 96, 172),
                        fontWeight: FontWeight.w100,
                        fontSize: 30,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Log in',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 40),
                Text(
                  'User Name',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: loginUserNameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: 'usern123'),
                  validator: (value) => value == null || value.isEmpty ? 'User Name is required' : null,
                ),
                const SizedBox(height: 30),
                Text(
                  'Password',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 10),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    bool isPasswordVisible = state is PasswordVisibleState ? state.isPasswordVisible : false;

                    return TextFormField(
                      controller: loginPasswordController,
                      keyboardType: TextInputType.name,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: '',
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => context.read<AuthBloc>().add(TogglePasswordVisibilityEvent()),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Password is required' : null,
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('Forgot password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is SignInClickLoadingState) {
                          // Show loading overlay
                          showLoadingOverlay(context);
                        } else if (state is SignInClickErrorState) {
                          // Hide loading overlay
                          hideLoadingOverlay(context);

                          // Show error SnackBar
                          AppSnackBar.showCustomSnackBar(context, state.errorMessage.toString(), true, isTop: true);
                        } else if (state is SignInLoadingSuccessState) {
                          // Hide loading overlay
                          hideLoadingOverlay(context);
                          // Show success SnackBar
                          AppSnackBar.showCustomSnackBar(context, 'Welcome Back ${state.successMessage.userName}', false, isTop: true);
                          // navigate to main page
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => BottomNavigationView(),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              context.read<AuthBloc>().add(
                                    SignInClickEvent(
                                      userName: loginUserNameController.text,
                                      password: loginPasswordController.text,
                                    ),
                                  );
                            },
                            child: Text(
                              'Log In',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: AppColors.whiteColor,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                _buildDivider(context),
                _buildSignUp(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildDivider(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 18.0),
    child: Row(
      spacing: 10,
      children: [
        Expanded(child: Divider()),
        Text(
          'Or',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Expanded(child: Divider()),
      ],
    ),
  );
}

Widget _buildSignUp(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Don\'t have and account?'),
      TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SignUpPageView(),
            ),
          );
        },
        child: Text('Register now'),
      ),
    ],
  );
}
