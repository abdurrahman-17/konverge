import 'package:flutter/cupertino.dart';

class ListTransition {


  AnimatedList getWaterFallTransition(
      {required int count, required, required GlobalKey<AnimatedListState> listKey,required AnimatedItemBuilder itemBuilder}) {
    print("count $count");
    return AnimatedList(
      key: listKey,
      initialItemCount: count,
      itemBuilder: itemBuilder// Refer step 3
    );
  }
}
