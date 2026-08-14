import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:base32/base32.dart';
import '../../logic/totp_bloc/totp_bloc.dart';
import '../../logic/totp_bloc/totp_event.dart';
import '../../data/models/totp_item.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({Key? key}) : super(key: key);

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final _accountController = TextEditingController();
  final _issuerController = TextEditingController();
  final _secretController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _accountController.dispose();
    _issuerController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    final account = _accountController.text.trim();
    final issuer = _issuerController.text.trim();
    String secret = _secretController.text.trim().replaceAll(' ', '').toUpperCase();

    if (account.isEmpty || secret.isEmpty) {
      setState(() => _errorMessage = 'Account name and secret key are required');
      return;
    }

    // Basic Base32 validation
    try {
      base32.decode(secret);
    } catch (e) {
      setState(() => _errorMessage = 'Invalid secret key format (must be Base32)');
      return;
    }

    final item = TotpItem(
      id: const Uuid().v4(),
      issuer: issuer,
      accountName: account,
      secret: secret,
    );

    context.read<TotpBloc>().add(AddTotpItem(item));
    Navigator.pop(context); // Go back to Home
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
              const Text('Enter Setup Key', style: AppTextStyles.heading1),
              const SizedBox(height: 12),
              const Text(
                'Enter the details provided by the service you want to secure. The secret key is a long string of letters and numbers (Base32 format).',
                style: AppTextStyles.bodyText,
              ),
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
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Secret Key',
                hint: 'Enter the base32 key',
                controller: _secretController,
                isSecret: true,
                textCapitalization: TextCapitalization.characters,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(_errorMessage!, style: const TextStyle(color: AppColors.error)),
              ],
              const SizedBox(height: 48),
              CustomButton(
                text: 'Add Account',
                onPressed: _handleAdd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
