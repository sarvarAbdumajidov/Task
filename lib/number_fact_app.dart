import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interesting_number/features/number/data/repositories/number_fact_repository.dart';
import 'package:interesting_number/features/number/presentation/bloc/number_bloc.dart';
import 'package:interesting_number/features/number/presentation/pages/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberFactApp extends StatelessWidget {
  const NumberFactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<NumberBloc>(create: (_) => NumberBloc(repository: NumberFactRepository())),
          ],
          child: MaterialApp(debugShowCheckedModeBanner: false, home: child),
        );
      },

      child: HomePage(),
    );
  }
}
