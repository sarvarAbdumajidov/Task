import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interesting_number/core/utils/enums.dart';
import 'package:interesting_number/features/number/data/models/number_model.dart';

import 'package:interesting_number/features/number/presentation/bloc/number_bloc.dart';
import 'package:interesting_number/features/number/presentation/bloc/number_event.dart';
import 'package:interesting_number/features/number/presentation/bloc/number_state.dart';
import 'package:interesting_number/features/number/presentation/pages/saved_data_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:interesting_number/features/number/data/services/hive_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController numberController = TextEditingController();
  Type selectedType = Type.trivia;
  bool isRandom = false;
  bool isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _isConnect();
  }

  void _isConnect() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final wasOffline = isOffline;
      setState(() {
        isOffline = results.contains(ConnectivityResult.none);
      });

      if (!wasOffline && isOffline) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          const SnackBar(
            content: Text("No Internet Connection", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    numberController.dispose();
    connectivitySubscription!.cancel();
  }

  void _showFactBottomSheet(Number numberFact) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (_) => Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Result", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  10.verticalSpace,
                  Text(numberFact.text, style: TextStyle(fontSize: 16.sp)),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          HiveService().saveNumber(numberFact);

                          numberController.clear();
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Fact Save", style: TextStyle(color: Colors.white)),
                              backgroundColor: Color.fromARGB(255, 20, 202, 114),
                            ),
                          );
                        },
                        child: Text("Save", style: TextStyle(fontSize: 14.sp)),
                      ),
                      TextButton(
                        onPressed: () {
                          numberController.clear();
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        child: Text("Close", style: TextStyle(fontSize: 14.sp)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _onGetFactPressed() {
    if (isOffline) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No Internet connection", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    int? number;
    if (!isRandom) {
      number = int.tryParse(numberController.text.trim());
      if (number == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Number entered incorrectly", style: TextStyle(color: Colors.white)),
          ),
        );
        return;
      }
    }

    context.read<NumberBloc>().add(
      GetNumberFact(number: isRandom ? null : number, type: selectedType, isRandom: isRandom),
    );
  }

  void _openSavedPageWithScaleTransition() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, animation, __) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomRight,
            child: const SavedPage(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade100,
        title: Text("Interesting numbers", style: TextStyle(fontSize: 18.sp, color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  autocorrect: false,
                  autofocus: false,
                  onFieldSubmitted: (_) => _onGetFactPressed(),
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  enabled: !isRandom,
                  style: TextStyle(fontSize: 16.sp),
                  decoration: InputDecoration(
                    labelText: "Enter a number",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter number";
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return "Only number needed";
                    }
                    return null;
                  },
                ),
              ),

              10.h.verticalSpace,
              Row(
                children: [
                  Text("Random number", style: TextStyle(fontSize: 14.sp)),
                  Checkbox(value: isRandom, onChanged: (val) => setState(() => isRandom = val!)),
                ],
              ),
              10.h.verticalSpace,
              DropdownButton<Type>(
                value: selectedType,
                isExpanded: true,

                items:
                    Type.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name, style: TextStyle(fontSize: 14.sp)),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => selectedType = val!),
              ),
              20.h.verticalSpace,
              MaterialButton(
                color: Colors.deepPurple.shade400,
                onPressed: _onGetFactPressed,
                child: Text('Get Facts', style: TextStyle(fontSize: 14.sp, color: Colors.white)),
              ),
              20.h.verticalSpace,
              BlocConsumer<NumberBloc, NumberState>(
                listener: (context, state) {
                  if (state is NumberLoaded) {
                    _showFactBottomSheet(state.number);
                  } else if (state is NumberError) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text(state.message, style: TextStyle(color: Colors.white)),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is NumberLoading) {
                    return const CircularProgressIndicator();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openSavedPageWithScaleTransition,
        child: const Icon(Icons.save),
      ),
    );
  }
}
