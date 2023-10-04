import'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    required this.child,
    required this.value,
    this.color = Colors.red }) : super(key: key);

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        child,
        Positioned(
          top: 8,
            right: 8,
            child: Container(

              margin: EdgeInsets.only(top: 5),
              alignment: Alignment.center,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color,

              ),
              child: FittedBox(
                child: Text(value,
                style:TextStyle(
                  color: Colors.white
                )),
              ),
            )
        ),
      ],
    );
  }
}
