import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

typedef AdditionWidgetBuilder<T extends Object> = Widget Function(
    BuildContext context, ValueNotifier<T?> notifier);

typedef SavedCallback<T extends Object> = Future<void> Function(T saved);

class AdditionWidget<T extends Object> extends StatefulWidget {
  final T? value;
  final AdditionWidgetBuilder<T> builder;
  final SavedCallback<T> onSave;
  final VoidCallback? onAdd;
  final VoidCallback? onCancel;

  const AdditionWidget(
      {Key? key,
      this.onAdd,
      this.onCancel,
      this.value,
      required this.onSave,
      required this.builder})
      : super(key: key);

  @override
  State<AdditionWidget> createState() => _AdditionWidgetState<T>();
}

class _AdditionWidgetState<T extends Object> extends State<AdditionWidget<T>> {
  late final ValueNotifier<T?> _notifier;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier<T?>(widget.value);
    // Update this widget when value changed
    _notifier.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DottedBorder(
      color: Theme.of(context).colorScheme.secondary,
      strokeWidth: 1,
      borderType: BorderType.RRect,
      radius: const Radius.circular(4.0),
      child: (!_isAdding)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (widget.onAdd != null) {
                        widget.onAdd!();
                      }
                      setState(() {
                        _isAdding = true;
                      });
                    },
                    icon: Icon(Icons.add_circle_outline_rounded,
                        size: 32,
                        color: Theme.of(context).colorScheme.secondary))
              ],
            )
          : Column(
              children: [
                widget.builder(context, _notifier),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_notifier.value != null)
                      IconButton(
                          onPressed: () async {
                            await widget.onSave(_notifier.value!);
                            setState(() {
                              _isAdding = false;
                              _notifier.value = null;
                            });
                          },
                          icon: const Icon(Icons.check)),
                    IconButton(
                        onPressed: () {
                          if (widget.onCancel != null) {
                            widget.onCancel!();
                          }
                          setState(() {
                            _isAdding = false;
                            _notifier.value = null;
                          });
                        },
                        icon: const Icon(Icons.close)),
                  ],
                )
              ],
            ));
}
