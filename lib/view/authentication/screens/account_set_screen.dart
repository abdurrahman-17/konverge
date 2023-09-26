import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utilities/common_functions.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../common_widgets/loading_widget.dart';
import 'success_screen.dart';

import '../../../utilities/styles/common_styles.dart';

class AccountSetScreen extends StatefulWidget {
  static const String routeName = 'account_set';

  const AccountSetScreen({super.key});

  @override
  State<AccountSetScreen> createState() => _AccountSetScreenState();
}

bool isLoading = false;

class _AccountSetScreenState
    extends State<AccountSetScreen> // with TickerProviderStateMixin
{
  // late Animation<double> _animationCurve;
  // late Animation<double> _animationSize;
  // AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GraphqlBloc>(context).add(
      const ReadLoggedInUserInfoEvent(),
    );
    // _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300))
    //   ..addListener(() {
    //     if (mounted) {
    //       setState(() {});
    //     }
    //   })
    //   ..repeat(reverse: true);
    // final animation = CurvedAnimation(parent: _controller!, curve: Curves.easeInOutCubic);
    // _animationCurve = Tween(begin: 1.0, end: 0.0).animate(animation);
    // _animationSize = Tween(begin: 0.5, end: 1.0).animate(animation);
  }

  void startTimer() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
          context, SuccessScreen.routeName, (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: contents(context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  // double _opacity = 1;

  Widget contents(BuildContext context) {
    return BlocListener<GraphqlBloc, GraphqlState>(
      listener: (BuildContext context, state) {
        isLoading = false;
        switch (state.runtimeType) {
          case ReadUserSuccessState:
            addPlayerId(context);
            WidgetsBinding.instance.addPostFrameCallback((_) => startTimer());
            break;
          case GraphqlErrorState:
            print(
                "GraphqlErrorState: $state ${(state as GraphqlErrorState).errorMessage}");
            break;
          default:
            print("Unknown state while logging in: $state");
        }
      },
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingWidget(),
          ],
        ),
      ),
    );
  }
}
