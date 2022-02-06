import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'package:url_launcher/url_launcher.dart';



class ScratchBox extends StatefulWidget {
  ScratchBox({
    required this.image,
    this.onScratch,
    this.animation,
  });

  final String image;
  final VoidCallback? onScratch;
  final Animation<double>? animation;

  @override
  _ScratchBoxState createState() => _ScratchBoxState();
}

class _ScratchBoxState extends State<ScratchBox> {
  bool isScratched = false;
  double opacity = 0.4;

  @override
  Widget build(BuildContext context) {
    var icon = AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 750),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            widget.image,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                Text(
                  !isScratched
                      ? 'Lì xì là thẻ cào 10'
                      : 'Lì xì là thẻ cào VT 100k:',
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
                if (isScratched)
                  GestureDetector(
                    child: const Text(
                      '322870237059861',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    onTap: () async{
                     await launch('tel://*100*322870237059861#');
                    },
                  ),
                if (isScratched)
                  const Text(
                    'Chúc bạn và gia đình năm mới an khang thịnh vượng',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                if (isScratched)
                  const Text(
                    'Nhấn vào mã thẻ để nạp ngay!',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
              ],
            ),
          )
        ],
      ),
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Scratcher(
          accuracy: ScratchAccuracy.low,
          color: Colors.blueGrey,
          image: Image.asset('asset/image/lixi.png',),
          brushSize: 20,
          threshold: 60,
          onThreshold: () {
            setState(() {
              opacity = 1;
              isScratched = true;
            });
            widget.onScratch?.call();
          },
          child: icon),
    );
  }
}
