import 'package:flutter/material.dart';

class SlotItem extends StatefulWidget {
  final String name;
  final String id;
  final bool filled;

  SlotItem(this.name, this.id, this.filled);
  @override
  State<SlotItem> createState() => _SlotItemState();
}

class _SlotItemState extends State<SlotItem> {
  var _filled = false;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: TextButton(
        child: Text(widget.name),
        onPressed: widget.filled
            ? null
            : () {
                setState(() {
                  _filled = !_filled;
                });
              },
        style: ButtonStyle(
            backgroundColor: widget.filled || _filled
                ? MaterialStateProperty.all<Color>(Colors.red)
                : MaterialStateProperty.all<Color>(Colors.white),
            foregroundColor: widget.filled || _filled
                ? MaterialStateProperty.all<Color>(Colors.white)
                : MaterialStateProperty.all<Color>(Colors.green)),
      ),
    );
  }
}
