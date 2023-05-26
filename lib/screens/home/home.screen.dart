import 'package:events_emitter/events_emitter.dart';
import 'package:fintracker/dao/account_dao.dart';
import 'package:fintracker/dao/payment_dao.dart';
import 'package:fintracker/global_event.dart';
import 'package:fintracker/helpers/currency.helper.dart';
import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:fintracker/model/payment.model.dart';
import 'package:fintracker/screens/home/widgets/account_slider.dart';
import 'package:fintracker/screens/home/widgets/payment_list_item.dart';
import 'package:fintracker/screens/payment_form.screen.dart';
import 'package:fintracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PaymentDao _paymentDao = PaymentDao();
  final AccountDao _accountDao = AccountDao();
  EventListener? _accountEventListener;
  EventListener? _categoryEventListener;
  EventListener? _paymentEventListener;
  List<Payment> _payments = [];
  List<Account> _accounts = [];
  double _income = 0;
  double _expense = 0;
  //double _savings = 0;
  DateTimeRange _range = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: DateTime.now().day -1)),
      end: DateTime.now()
  );
  Account? _account;
  Category? _category;

  void openAddPaymentPage(PaymentType type) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>PaymentForm(type: type)));
  }

  void handleChooseDateRange() async{
    final selected = await showDateRangePicker(
      context: context,
      initialDateRange: _range,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    );
    if(selected != null) {
      setState(() {
        _range = selected;
        _fetchTransactions();
      });
    }
  }

  void _fetchTransactions() async {
    List<Payment> trans = await _paymentDao.find(range: _range, category: _category, account:_account);
    double income = 0;
    double expense = 0;
    for (var payment in trans) {
      if(payment.type == PaymentType.credit) income += payment.amount;
      if(payment.type == PaymentType.debit) expense += payment.amount;
    }

    //fetch accounts
    List<Account> accounts = await _accountDao.find(withSummery: true);

    setState(() {
      _payments = trans;
      _income = income;
      _expense = expense;
      _accounts = accounts;
    });
  }


  @override
  void initState() {
    super.initState();
    _fetchTransactions();

    _accountEventListener = globalEvent.on("account_update", (data){
      debugPrint("accounts are changed");
      _fetchTransactions();
    });

    _categoryEventListener = globalEvent.on("category_update", (data){
      debugPrint("categories are changed");
      _fetchTransactions();
    });

    _paymentEventListener = globalEvent.on("payment_update", (data){
      debugPrint("payments are changed");
      _fetchTransactions();
    });

  }

  @override
  void dispose() {
    _accountEventListener?.cancel();
    _categoryEventListener?.cancel();
    _paymentEventListener?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: (){
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text("Home", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi! Good ${greeting()}"),
                    // Text("Guest", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              SizedBox(
                height: 190,
                width: double.infinity,
                child: AccountsSlider(accounts: _accounts,),
              ),

              const SizedBox(height: 15,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                    children: [
                      const Text("Payments", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
                      const Expanded(child: SizedBox()),
                      MaterialButton(
                        onPressed: (){
                          handleChooseDateRange();
                        },
                        height: double.minPositive,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        child: Row(
                          children: [
                            Text("${DateFormat("dd MMM").format(_range.start)} - ${DateFormat("dd MMM").format(_range.end)}", style: Theme.of(context).textTheme.bodySmall,),
                            const Icon(Icons.arrow_drop_down_outlined)
                          ],
                        ),
                      ),
                    ]
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: ThemeColors.success.withOpacity(0.2),
                            ),
                            child: SizedBox(
                              width: double.infinity,
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
                                  const SizedBox(height: 5,),
                                  Text(CurrencyHelper.format(_income), style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ThemeColors.success, fontFamily: GoogleFonts.jetBrainsMono().fontFamily),)
                                ],
                              ),
                            )
                        )
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: ThemeColors.error.withOpacity(0.2),
                            ),
                            child: SizedBox(
                              width: double.infinity,
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
                                  const SizedBox(height: 5,),
                                  Text(CurrencyHelper.format(_expense), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ThemeColors.error, fontFamily: GoogleFonts.jetBrainsMono().fontFamily),)
                                ],
                              ),
                            )
                        )
                    ),
                  ],
                ),
              ),
              ListView.separated(
                padding:  EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index){
                  return PaymentListItem(payment: _payments[index], onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>PaymentForm(type: _payments[index].type, payment: _payments[index],)));
                  });

                },
                separatorBuilder: (BuildContext context, int index){
                  return Container(
                    width: double.infinity,
                    color: Colors.grey.withAlpha(25),
                    height: 1,
                    margin: const EdgeInsets.only(left: 75, right: 20),
                  );
                },
                itemCount: _payments.length,
              ),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> openAddPaymentPage(PaymentType.credit),
        child: const Icon(Icons.add),
      ),
    );
  }
}
