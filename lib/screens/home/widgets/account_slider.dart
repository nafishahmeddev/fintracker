import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/widgets/currency.dart';
import 'package:flutter/material.dart';

class AccountsSlider extends StatefulWidget{
  final List<Account> accounts;
  const AccountsSlider({super.key, required this.accounts});
  @override
  State<StatefulWidget> createState()=>_AccountSlider();
}

class _AccountSlider extends State<AccountsSlider>{
  final PageController _pageController = PageController();
  int _selected = 0;
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 170,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.accounts.length,
            controller: _pageController,
            onPageChanged: (int index){
              setState(() {
                _selected = index;
              });
            },
            itemBuilder : (BuildContext builder, int index) {
              Account account = widget.accounts[index];
              return FractionallySizedBox(
                widthFactor: 1 / _pageController.viewportFraction,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          stops: const [
                            0.1,
                            0.9
                          ],
                          colors: [
                            account.color.withOpacity(0.7),
                            account.color.withOpacity(1)
                          ]
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CurrencyText(account.balance ?? 0, style: Theme.of(context).textTheme.headlineMedium?.merge(
                                const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700
                                ),
                              )),
                              Text("Balance", style: Theme.of(context).textTheme.bodyMedium?.apply(color: Colors.white.withOpacity(0.9)),),
                              const Expanded(child: SizedBox()),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(account.holderName, style: Theme.of(context).textTheme.bodyLarge?.apply(color: Colors.white.withOpacity(1), fontWeightDelta: 2),),
                                      Text(account.name, style: Theme.of(context).textTheme.bodySmall?.apply(color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center,),
                                    ],
                                  ),
                                  const Expanded(child:SizedBox()),
                                  Icon(account.icon, color: Colors.white)
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                ),
              );
            },
          ),
        ),
        if(widget.accounts.length > 1) const SizedBox(height: 10,),
        if(widget.accounts.length > 1) SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.accounts.length, (index) {
              return AnimatedContainer(
                curve: Curves.ease,
                height: 6,
                duration: const Duration(milliseconds: 200),
                width: _selected == index? 20: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(_selected == index? 1:0.5),
                    borderRadius: BorderRadius.circular(60)
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}

