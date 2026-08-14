import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';
import 'qr_scanner_screen.dart';
import 'manual_entry_screen.dart';

class AddAccountScreen extends StatelessWidget {
  const AddAccountScreen({Key? key}) : super(key: key);

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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Account', style: AppTextStyles.heading1),
              const SizedBox(height: 12),
              const Text(
                'Secure your accounts with Two-Factor Authentication. Scanning a QR code is the fastest method.',
                style: AppTextStyles.bodyText,
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'Scan QR Code',
                icon: Icons.qr_code_scanner,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const QrScannerScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Enter Setup Key',
                icon: Icons.keyboard,
                color: AppColors.surface,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ManualEntryScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
