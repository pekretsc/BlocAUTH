import 'package:flutter/material.dart';

class SelfUpdatingCheckBox extends StatefulWidget {
  bool initState;
  Color activeColor;
  Color checkColor;
  bool tristate;
  Key key;
  Function onChanged;
  MaterialTapTargetSize materialTapTargetSize;
  SelfUpdatingCheckBox(
      {@required this.initState,
      @required this.onChanged,
      this.key,
      this.materialTapTargetSize,
      this.tristate,
      this.checkColor,
      this.activeColor});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelfUpdatingCheckBox();
  }
}

class _SelfUpdatingCheckBox extends State<SelfUpdatingCheckBox> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Checkbox(
        key: widget.key,
        materialTapTargetSize: widget.materialTapTargetSize,
        tristate: widget.tristate,
        checkColor: widget.checkColor,
        activeColor: widget.activeColor,
        value: widget.initState,
        onChanged: (_) {
          widget.onChanged;
          widget.initState = !widget.initState;
          setState(() {});
        });
  }
}
