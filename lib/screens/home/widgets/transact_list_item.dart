import 'package:fintracker/model/transaction.model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../helpers/currency.helper.dart';
import '../../../theme/colors.dart';

class TransactionListItem extends StatelessWidget{
  final Transaction transaction;
  final VoidCallback onTap;
  const TransactionListItem({super.key, required this.transaction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isCredit = transaction.type == TransactionType.CREDIT ;
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25)
      ),
      onTap: onTap,
      leading: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: transaction.category.color.withOpacity(0.1),
          ),
          child:  Icon( transaction.category.icon, size: 22, color: transaction.category.color,)
      ),
      title: Text(transaction.category.name, style: Theme.of(context).textTheme.bodyMedium?.merge(const TextStyle(fontWeight: FontWeight.w500)),),
      subtitle: Text.rich(
        TextSpan(
            children: [
              TextSpan(text: (DateFormat("dd MMM yyyy, HH:mm").format(transaction.datetime))),
            ],
            style: Theme.of(context).textTheme.bodySmall?.apply(color: Colors.grey, overflow: TextOverflow.ellipsis)
        ),
      ),
      trailing: Text(
          CurrencyHelper.format(isCredit? transaction.amount : -transaction.amount),
          style: Theme.of(context).textTheme.bodyMedium?.apply(color: isCredit? ThemeColors.success:ThemeColors.error, fontFamily: GoogleFonts.manrope().fontFamily)
      ),
    ) ;
  }

}