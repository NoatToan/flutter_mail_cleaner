import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

/// Colored square with the provider initial (G / O / i). Used by the sidebar,
/// mail rows, settings and onboarding — no stock widget covers it.
class AccountBadge extends StatelessWidget {
  const AccountBadge({required this.provider, this.size = 16, super.key});

  final MailProviderType provider;
  final double size;

  static Color colorOf(MailProviderType p) => switch (p) {
    MailProviderType.gmail => AppPalette.gmail,
    MailProviderType.outlook => AppPalette.outlook,
    MailProviderType.icloud => AppPalette.icloud,
    MailProviderType.imap => AppPalette.imap,
    MailProviderType.demo => AppPalette.demo,
  };

  static String initialOf(MailProviderType p) => switch (p) {
    MailProviderType.gmail => 'G',
    MailProviderType.outlook => 'O',
    MailProviderType.icloud => 'i',
    MailProviderType.imap => '@',
    MailProviderType.demo => 'D',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorOf(provider),
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Text(
        initialOf(provider),
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.58,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
