import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '/utils/waifu_2x_updater.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
      width: 0.25 * width,
      height: 81,
      constraints: const BoxConstraints(
        minWidth: 280,
        maxWidth: 400,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Center(
        child: SpinKitRing(
          color: Theme.of(context).colorScheme.primary,
          size: 50,
        ),
      ),
    );
  }
}
