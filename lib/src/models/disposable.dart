
import 'package:meta/meta.dart';

abstract class Disposable {
  bool _disposed = false;
  bool get disposed => _disposed;

  @protected
  void disposeInstance();

  void dispose() {
    disposeInstance();
    _markDisposed();
  }

  void _markDisposed() {
    _disposed = true;
  }
}
