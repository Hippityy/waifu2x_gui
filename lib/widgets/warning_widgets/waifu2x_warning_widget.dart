import 'package:flutter/material.dart';

import '/utils/waifu_2x_updater.dart';

class WaifuNotFoundWidget extends StatelessWidget {
  const WaifuNotFoundWidget({
    Key? key,
    required this.width,
    required this.ticker,
    required this.onChanged,
  }) : super(key: key);

  final double width;
  final TickerProvider ticker;
  final ValueChanged<void> onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
      width: 0.25 * width,
      constraints: const BoxConstraints(
        minWidth: 280,
        maxWidth: 400,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(children: [
        const SizedBox(height: 8.0),
        Text(
            style: Theme.of(context).textTheme.titleMedium,
            'Waifu2x not found.'),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                debugPrint('Download Pressed');
                InstallWaifuExe(
                  ticker: ticker,
                  onChanged: (value) => onChanged(null),
                );
              },
              // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
              style: ElevatedButton.styleFrom(
                elevation: 3.0,
                textStyle: Theme.of(context).textTheme.button,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('Download'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                debugPrint('SetPath Pressed');
                await setPath();
                onChanged(null);
              },
              // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
              style: ElevatedButton.styleFrom(
                elevation: 3.0,
                textStyle: Theme.of(context).textTheme.button,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('Set Path'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
      ]),
    );
  }
}
