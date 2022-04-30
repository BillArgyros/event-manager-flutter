import 'package:flutter/material.dart';


class PopupMenuWidget<T> extends PopupMenuEntry<T> {
  const PopupMenuWidget({ required this.height, required this.child });

  final Widget child;

  @override
  final double height;

  bool get enabled => false;

  @override
  _PopupMenuWidgetState createState() => _PopupMenuWidgetState();

  @override
  bool represents(T? value) {
    throw UnimplementedError();
  }
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) => widget.child;
}