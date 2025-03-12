import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/core/app_loading_card.dart';
import 'package:expense_tracker/core/app_snack_bar.dart';
import 'package:expense_tracker/features/auth/domain_layer/sign_in_up_entity.dart/sign_up_entity.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePageView extends StatefulWidget {
  final String userName;
  final String address;
  final String phoneNumber;
  final String password;
  final int id;
  const EditProfilePageView({
    required this.userName,
    required this.address,
    required this.password,
    required this.phoneNumber,
    required this.id,
    super.key,
  });

  @override
  State<EditProfilePageView> createState() => _EditProfilePageViewState();
}

class _EditProfilePageViewState extends State<EditProfilePageView> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordHashController = TextEditingController();
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.userName;
    phoneNumberController.text = widget.phoneNumber;
    addressController.text = widget.address;
    passwordHashController.text = widget.password;
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: loginKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 26),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back),
                ),
                const SizedBox(height: 36),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildTextField('User Name', userNameController),
                const SizedBox(height: 30),
                _buildTextField('Address', addressController),
                const SizedBox(height: 30),
                _buildTextField('Phone', phoneNumberController, isNumber: true),
                const SizedBox(height: 30),
                _buildPasswordField(),
                const SizedBox(height: 20),
                _buildUpdateButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: const Color.fromARGB(255, 20, 96, 172),
                fontWeight: FontWeight.w100,
                fontSize: 30,
              ),
        ),
        const SizedBox(height: 10),
        Text('Edit Profile', style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextLabel(textTitle: label),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(hintText: label.toLowerCase()),
          validator: (value) => value == null || value.isEmpty ? '$label is required' : null,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool isPasswordVisible = state is PasswordVisibleState ? state.isPasswordVisible : false;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextLabel(textTitle: 'Password'),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordHashController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => context.read<AuthBloc>().add(TogglePasswordVisibilityEvent()),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUpdateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ProfileUpDateClickLoadingState) {
              showLoadingOverlay(context);
            } else if (state is ProfileUpDateClickErrorState) {
              hideLoadingOverlay(context);
              AppSnackBar.showCustomSnackBar(context, state.message.toString(), true, isTop: true);
            } else if (state is ProfileUpDateClickLoadedState) {
              hideLoadingOverlay(context);
              AppSnackBar.showCustomSnackBar(context, state.signUpEntity.toString(), false, isTop: true);
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
                                ProfileUpDateClickEvent(
                                  userName: userNameController.text,
                                  signUpEntity: SignUpEntity(
                                    id: widget.id,
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
                  'Update',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.whiteColor,
                      ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class TextLabel extends StatelessWidget {
  final String textTitle;
  const TextLabel({required this.textTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      textTitle,
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}
