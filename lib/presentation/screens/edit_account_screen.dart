import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/totp_bloc/totp_bloc.dart';
import '../../logic/totp_bloc/totp_event.dart';
import '../../data/models/totp_item.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

class EditAccountScreen extends StatefulWidget {
  final TotpItem item;

  const EditAccountScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late final TextEditingController _accountController;
  late final TextEditingController _issuerController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController(text: widget.item.accountName);
    _issuerController = TextEditingController(text: widget.item.issuer);
  }

  @override
  void dispose() {
    _accountController.dispose();
    _issuerController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final account = _accountController.text.trim();
    final issuer = _issuerController.text.trim();

    if (account.isEmpty) {
      setState(() => _errorMessage = 'Account name is required');
      return;
    }

    final updatedItem = widget.item.copyWith(
      accountName: account,
      issuer: issuer,
    );

    context.read<TotpBloc>().add(UpdateTotpItem(updatedItem));
    Navigator.pop(context); // Go back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Account', style: AppTextStyles.heading1),
              const SizedBox(height: 32),
              CustomTextField(
                label: 'Account Name',
                hint: 'e.g. mahesh@example.com',
                controller: _accountController,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Issuer (Optional)',
                hint: 'e.g. Google, GitHub',
                controller: _issuerController,
                textCapitalization: TextCapitalization.words,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(_errorMessage!, style: const TextStyle(color: AppColors.error)),
              ],
              const SizedBox(height: 48),
              CustomButton(
                text: 'Save Changes',
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
