import 'package:events_emitter/events_emitter.dart';
import 'package:fintracker/dao/category_dao.dart';
import 'package:fintracker/global_event.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:fintracker/widgets/dialog/category_form.dialog.dart';
import 'package:flutter/material.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryDao _categoryDao = CategoryDao();
  EventListener? _categoryEventListener;
  List<Category> _categories = [];


  void loadData() async {
    List<Category> categories = await _categoryDao.find();
    setState(() {
      _categories = categories;
    });
  }


  @override
  void initState() {
    super.initState();
    loadData();

    _categoryEventListener = io.on("category_update", (data){
      debugPrint("categories are changed");
      loadData();
    });


  }

  @override
  void dispose() {

    _categoryEventListener?.cancel();

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
          title: const Text("Categories", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 15),
            itemCount: _categories.length,
            itemBuilder: (builder, index){
              Category category = _categories[index];
              double expenseProgress = (category.expense??0)/(category.budget??0);
              return ListTile(
                onTap: (){
                  showDialog(context: context, builder: (builder)=>CategoryForm(category: category,));
                },
                leading: CircleAvatar(backgroundColor: category.color.withOpacity(0.2),child: Icon(category.icon, color: category.color,),),
                title: Text(category.name),
                subtitle: expenseProgress.isFinite? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(value: expenseProgress, semanticsLabel: expenseProgress.toString(),),
                ):null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)
                ),
              );
            }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context, builder: (builder)=>const CategoryForm());
          },
          child: const Icon(Icons.add),
        )
    );
  }
}
