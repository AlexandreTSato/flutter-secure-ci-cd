import 'package:flutter/material.dart';

class BankIconHeader extends StatelessWidget {
  const BankIconHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.account_balance_wallet_rounded,
      color: Colors.white,
      size: 72,
    );
  }
}
