import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Provider logo: the official Gmail / Outlook / iCloud marks (SVGs in
/// `assets/brand/`), a neutral "@" tile for generic IMAP and a flask for the
/// demo mailbox. Used by the sidebar, mail rows, filters, settings and
/// onboarding — no stock widget covers it.
class AccountBadge extends StatelessWidget {
  const AccountBadge({required this.provider, this.size = 16, super.key});

  final MailProviderType provider;
  final double size;

  /// Brand color, for the few places that need a flat accent (charts).
  static Color colorOf(MailProviderType p) => switch (p) {
    MailProviderType.gmail => AppPalette.gmail,
    MailProviderType.outlook => AppPalette.outlook,
    MailProviderType.icloud => AppPalette.icloud,
    MailProviderType.imap => AppPalette.imap,
    MailProviderType.demo => AppPalette.demo,
  };

  static String? _assetOf(MailProviderType p) => switch (p) {
    MailProviderType.gmail => 'assets/brand/gmail.svg',
    MailProviderType.outlook => 'assets/brand/outlook.svg',
    MailProviderType.icloud => 'assets/brand/icloud.svg',
    MailProviderType.imap || MailProviderType.demo => null,
  };

  @override
  Widget build(BuildContext context) {
    final asset = _assetOf(provider);
    if (asset != null) {
      return SizedBox.square(
        dimension: size,
        child: SvgPicture.asset(asset),
      );
    }
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorOf(provider),
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Icon(
        provider == MailProviderType.demo
            ? Icons.science_outlined
            : Icons.alternate_email,
        size: size * 0.7,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
