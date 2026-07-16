import 'package:flutter/material.dart';

class DeferredPage extends StatefulWidget {
  const DeferredPage({
    super.key,
    required this.loadLibrary,
    required this.page,
  });

  final Future<dynamic> Function() loadLibrary;
  final Widget Function() page;

  @override
  State<DeferredPage> createState() => _DeferredPageState();
}

class _DeferredPageState extends State<DeferredPage> {
  var _ready = false;

  @override
  void initState() {
    super.initState();
    widget.loadLibrary().then((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    return widget.page();
  }
}
