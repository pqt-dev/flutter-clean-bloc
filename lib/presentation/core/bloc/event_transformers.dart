import 'package:flutter_bloc/flutter_bloc.dart';

/// Processes events of the same type strictly one at a time: the handler for one
/// event — including its awaited work (e.g. a persistence write) — fully
/// completes before the next event of that type begins.
///
/// Use this for handlers that mutate persisted/shared state so rapid, repeated
/// dispatches (e.g. fast taps on a toggle) cannot read stale state and drop an
/// update. Without it, the default transformer processes events concurrently.
EventTransformer<E> sequential<E>() {
  return (events, mapper) => events.asyncExpand(mapper);
}
