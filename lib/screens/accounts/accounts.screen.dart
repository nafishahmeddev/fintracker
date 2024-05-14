import 'package:events_emitter/events_emitter.dart';
import 'package:fintracker/dao/account_dao.dart';
import 'package:fintracker/events.dart';
import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/theme/colors.dart';
import 'package:fintracker/widgets/currency.dart';
import 'package:fintracker/widgets/dialog/account_form.dialog.dart';
import 'package:fintracker/widgets/dialog/confirm.modal.dart';
import 'package:flutter/material.dart';

maskAccount(String value, [int lastLength = 4]){
  if(value.length <4 ) return value;
  int length = value.length - lastLength;
  String generated = "";
  if(length > 0){
    generated+= value.substring(0, length).split("").map((e) => e==" "? " ": "X").join("");
  }
  generated += value.substring(length);
  return generated;
}
class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final AccountDao _accountDao = AccountDao();
  EventListener? _accountEventListener;
  List<Account> _accounts = [];


  void loadData() async {
    List<Account> accounts = await _accountDao.find(withSummery: true);
    setState(() {
      _accounts = accounts;
    });
  }


  @override
  void initState() {
    super.initState();
    loadData();

    _accountEventListener = globalEvent.on("account_update", (data){
      debugPrint("accounts are changed");
      loadData();
    });


  }

  @override
  void dispose() {

    _accountEventListener?.cancel();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Accounts", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            itemCount: _accounts.length,
            itemBuilder: (builder, index){
              Account account = _accounts[index];
              GlobalKey accKey = GlobalKey();
              return Stack(
                children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          color: account.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(account.holderName.isEmpty ? "---": account.holderName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                                  Text(account.name, style: Theme.of(context).textTheme.bodySmall,),
                                  Text(account.accountNumber.isEmpty ? "---": maskAccount(account.accountNumber), style: Theme.of(context).textTheme.bodySmall,),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 20,),
                          const Text.rich(
                              TextSpan(
                                  children: [
                                    TextSpan(text:"Total Balance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ]
                              )
                          ),
                          CurrencyText(account.balance??0, style:  const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text.rich(
                                          TextSpan(
                                              children: [
                                                //TextSpan(text: "▼", style: TextStyle(color: ThemeColors.success)),
                                                TextSpan(text:"Income", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                              ]
                                          )
                                      ),
                                      CurrencyText(account.income??0, style:  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ThemeColors.success),)
                                    ],
                                  )
                              ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text.rich(
                                          TextSpan(
                                              children: [
                                                //TextSpan(text: "▲", style: TextStyle(color: ThemeColors.error)),
                                                TextSpan(text:"Expense", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                              ]
                                          )
                                      ),
                                      CurrencyText(account.expense??0, style:  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ThemeColors.error),)

                                    ],
                                  )
                              )
                            ],
                          )
                        ],
                      )
                  ),
                  Positioned(
                      right: 15,
                      bottom: 40,
                      child: Icon(account.icon, size: 20, color: account.color,)
                  ),

                  Positioned(
                      right: 0,
                      top: 0,
                    child:  IconButton(
                        key: accKey,
                        onPressed: (){
                          final RenderBox renderBox =
                          accKey.currentContext?.findRenderObject() as RenderBox;
                          final Size size = renderBox.size;
                          final Offset offset = renderBox.localToGlobal(Offset.zero);

                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                offset.dx,
                                offset.dy + size.height,
                                offset.dx + size.width,
                                offset.dy + size.height
                            ),
                            items: [
                              PopupMenuItem<String>(
                                value: '1',
                                child: const Text('Edit'),
                                onTap: (){
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    showDialog(context: context, builder: (builder)=>AccountForm(account: account,));
                                  });
                                },
                              ),
                              PopupMenuItem<String>(
                                value: '2',
                                child: const Text('Delete', style: TextStyle(color: ThemeColors.error),),
                                onTap: (){
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    ConfirmModal.showConfirmDialog(
                                        context,
                                        title: "Are you sure?",
                                        content: const Text("All the paymentswill be deleted belongs to this account"),
                                        onConfirm: () async {
                                          Navigator.pop(context);
                                          await _accountDao.delete(account.id!);
                                          globalEvent.emit("account_update");
                                        },
                                        onCancel: (){
                                          Navigator.pop(context);
                                        }
                                    );
                                  });
                                },
                              ),
                            ],
                          );
                        },
                        icon: const Icon(Icons.more_vert, size: 20,),
                    ),
                  )
                ],
              );
            }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context, builder: (builder)=>const AccountForm());
          },
          child: const Icon(Icons.add),
        )
    );
  }
}
