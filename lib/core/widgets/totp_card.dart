import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/totp_item.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/otp_util.dart';
import 'glassmorphism_container.dart';
import 'animated_progress_ring.dart';

class TotpCard extends StatefulWidget {
  final TotpItem item;
  final double progress;
  final int remainingSeconds;
  final VoidCallback onLongPress;

  const TotpCard({
    Key? key,
    required this.item,
    required this.progress,
    required this.remainingSeconds,
    required this.onLongPress,
  }) : super(key: key);

  @override
  State<TotpCard> createState() => _TotpCardState();
}

class _TotpCardState extends State<TotpCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isCopied = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleCopy() {
    final code = OtpUtil.generateTotp(widget.item.secret);
    Clipboard.setData(ClipboardData(text: code));
    setState(() => _isCopied = true);
    
    // Play subtle animation
    _controller.forward().then((_) => _controller.reverse());
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isCopied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final code = OtpUtil.generateTotp(widget.item.secret);
    final formattedCode = code.length == 6 
        ? '${code.substring(0, 3)} ${code.substring(3, 6)}'
        : code;

    return GestureDetector(
      onTap: _handleCopy,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: AppConstants.paddingMedium),
          child: GlassmorphismContainer(
            color: AppColors.surface.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.item.issuer.isEmpty ? widget.item.accountName : widget.item.issuer,
                                style: AppTextStyles.heading2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                              onPressed: widget.onLongPress,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                        if (widget.item.issuer.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              widget.item.accountName,
                              style: AppTextStyles.bodyText,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        const SizedBox(height: 12),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.2),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            _isCopied ? 'Copied!' : formattedCode,
                            key: ValueKey<String>(_isCopied ? 'copied' : formattedCode),
                            style: AppTextStyles.otpCode.copyWith(
                              color: _isCopied ? AppColors.secondary : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedProgressRing(
                    progress: widget.progress,
                    remainingSeconds: widget.remainingSeconds,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
