import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/core/app_loading_card.dart';
import 'package:expense_tracker/core/app_snack_bar.dart';
import 'package:expense_tracker/features/auth/domain_layer/sign_in_up_entity.dart/sign_up_entity.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPageView extends StatefulWidget {
  const SignUpPageView({super.key});

  @override
  State<SignUpPageView> createState() => _SignUpPageViewState();
}

class _SignUpPageViewState extends State<SignUpPageView> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordHashController = TextEditingController();
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  @override
  void dispose() {
    userNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    passwordHashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: loginKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 26),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back)),
                  const SizedBox(height: 36),
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
                    'Register',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 40),
                  TextLabel(textTitle: 'User Name'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: userNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: 'userName'),
                    validator: (value) => value == null || value.isEmpty ? 'userName is required' : null,
                  ),
                  const SizedBox(height: 30),
                  TextLabel(textTitle: 'Address'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: addressController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: 'address'),
                    validator: (value) => value == null || value.isEmpty ? 'address is required' : null,
                  ),
                  const SizedBox(height: 30),
                  TextLabel(textTitle: 'Phone'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'phone number'),
                    validator: (value) => value == null || value.isEmpty ? 'phone number is required' : null,
                  ),
                  const SizedBox(height: 30),
                  TextLabel(textTitle: 'Password'),
                  const SizedBox(height: 10),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      // bool isPasswordVisible = false;
                      // if (state is PasswordVisibleState) {
                      //   isPasswordVisible = state.isPasswordVisible;
                      // } else if (state is PasswordHiddenState) {
                      //   isPasswordVisible = state.isPasswordVisible;
                      // }
                      bool isPasswordVisible = state is PasswordVisibleState ? state.isPasswordVisible : false;

                      return TextFormField(
                        controller: passwordHashController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              context.read<AuthBloc>().add(TogglePasswordVisibilityEvent());
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is SignUpClickLoadingState) {
                            showLoadingOverlay(context);
                          } else if (state is SignUpClickErrorState) {
                            // Hide loading overlay
                            hideLoadingOverlay(context);

                            // Show error SnackBar
                            AppSnackBar.showCustomSnackBar(context, state.errorMessage.toString(), true, isTop: true);
                          } else if (state is SignUpLoadingSuccessState) {
                            // Hide loading overlay
                            hideLoadingOverlay(context);
                            // Show success SnackBar
                            AppSnackBar.showCustomSnackBar(context, state.successMessage.toString(), false, isTop: true);

                            Navigator.of(context).pop();
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
                              onPressed: state is SignUpClickLoadingState
                                  ? null
                                  : () {
                                      if (loginKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                              SignUpClickEvent(
                                                signUpEntity: SignUpEntity(
                                                  userName: userNameController.text.trim(),
                                                  phoneNumber: phoneNumberController.text.trim(),
                                                  address: addressController.text.trim(),
                                                  passwordHash: passwordHashController.text.trim(),
                                                ),
                                              ),
                                            );
                                      }
                                    },
                              child: Text(
                                'Register',
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
                  const SizedBox(height: 30),
                  _buildHaveAccount(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextLabel extends StatelessWidget {
  final String textTitle;
  const TextLabel({
    required this.textTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textTitle,
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}

Widget _buildHaveAccount(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Already have an account?'),
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Login Now'))
    ],
  );
}
