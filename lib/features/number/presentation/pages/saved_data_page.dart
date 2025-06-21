import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interesting_number/features/number/data/models/number_model.dart';

import 'package:interesting_number/features/number/data/services/hive_service.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  late List<Number> saved;

  @override
  void initState() {
    super.initState();
    saved = HiveService().getAllNumbers();
  }

  void _deleteItem(int index) async {
    await HiveService().deleteNumber(index);
    setState(() {
      saved.removeAt(index);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 20, 202, 114),
        content: Text("Fact deleted", style: TextStyle(fontSize: 14.sp, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade100,
        centerTitle: true,
        title: Text("Saved Facts", style: TextStyle(fontSize: 18.sp, color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child:
            saved.isEmpty
                ? Center(child: Text("No saved facts", style: TextStyle(fontSize: 16.sp)))
                : ListView.builder(
                  itemCount: saved.length,
                  itemBuilder: (context, index) {
                    final fact = saved[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        // padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Colors.red,
                        ),
                        child: Icon(Icons.delete, color: Colors.white, size: 24.sp),
                      ),
                      onDismissed: (_) => _deleteItem(index),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        // margin: EdgeInsets.only(bottom: 10.h),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                          title: Text(fact.text, style: TextStyle(fontSize: 14.sp)),
                          subtitle: Text(
                            "Number: ${fact.number} | Type: ${fact.type}",
                            style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
