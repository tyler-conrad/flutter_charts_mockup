import 'package:flutter/material.dart' as m;

/// Detects pointer drags and calls the callback [_onPointerDrag].
class PointerDragListener extends m.StatefulWidget {
  const PointerDragListener({
    m.Key? key,
    required void Function(m.Offset?) onPointerDrag,
    required m.Widget child,
  })  : _onPointerDrag = onPointerDrag,
        _child = child,
        super(key: key);

  final void Function(m.Offset?) _onPointerDrag;
  final m.Widget _child;

  @override
  m.State<PointerDragListener> createState() => _PointerDragListenerState();
}

class _PointerDragListenerState extends m.State<PointerDragListener> {
  bool _pointerDown = false;

  @override
  m.Widget build(
    m.BuildContext context,
  ) {
    return m.Listener(
      onPointerDown: (m.PointerDownEvent event) {
        _pointerDown = true;
        widget._onPointerDrag(event.localPosition);
      },
      onPointerUp: (_) {
        _pointerDown = false;
        widget._onPointerDrag(null);
      },
      onPointerCancel: (_) {
        _pointerDown = false;
        widget._onPointerDrag(null);
      },
      onPointerMove: (m.PointerMoveEvent event) {
        if (_pointerDown) {
          widget._onPointerDrag(event.localPosition);
        }
      },
      child: widget._child,
    );
  }
}
