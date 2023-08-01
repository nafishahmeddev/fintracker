import 'package:currency_picker/currency_picker.dart';
import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyPicWidget extends StatefulWidget {
  const CurrencyPicWidget({super.key});

  @override
  State<StatefulWidget> createState() =>_CurrencyPicWidget();

}
class _CurrencyPicWidget extends State<CurrencyPicWidget>{
  final CurrencyService _currencyService = CurrencyService();
  String? _currency;
  String _keyword = "";

  List<Currency> filter(){
    if(_keyword.isEmpty){
      return _currencyService.getAll();
    }
    return _currencyService.getAll().where((element) => element.name.toLowerCase().contains(_keyword.toLowerCase())).toList();
  }

  @override
  void initState() {
    AppCubit cubit = context.read<AppCubit>();
    setState(() {
      _currency = cubit.state.currency;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppCubit cubit = context.read<AppCubit>();
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric( horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50,),
              const Icon(Icons.currency_exchange, size: 40,),
              const SizedBox(height: 15,),
              Text("Select Currency", style: theme.textTheme.headlineMedium!.apply(color: theme.colorScheme.primary, fontWeightDelta: 1),),
              const SizedBox(height: 25,),
              TextFormField(
                onChanged: (text){
                  setState(() {
                    _keyword = text;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search",
                ),
              ),
              const SizedBox(height: 25,),
              Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(filter().length, (index){
                        Currency currency = filter()[index];
                        return SizedBox(
                            width: (MediaQuery.of(context).size.width /2) -  20,
                            child: MaterialButton(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: BorderSide(
                                        width: 1.5,
                                        color: _currency == currency.code?  theme.colorScheme.primary : Colors.transparent
                                    )
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                                elevation: 0,
                                focusElevation: 0,
                                hoverElevation: 0,
                                highlightElevation: 0,
                                disabledElevation: 0,
                                onPressed: (){
                                  setState(() {
                                    _currency = currency.code;
                                  });
                                },
                                child:  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                          child: Text(currency.symbol),
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(currency.name, style: Theme.of(context).textTheme.bodyMedium?.apply(fontWeightDelta: 2), overflow: TextOverflow.ellipsis,),
                                        Text(currency.code, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis,),
                                      ],
                                    )
                                )
                            )
                        );
                      }),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          if(_currency == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select currency")));
          } else {
            cubit.updateCurrency(_currency);
            resetDatabase();
          }
        },
        label: const Row(
          children: <Widget>[Text("Next"), SizedBox(width: 10,), Icon(Icons.arrow_forward)],
        ),
      ),
    );
  }

}