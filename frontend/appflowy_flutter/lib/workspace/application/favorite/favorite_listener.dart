import 'dart:async';

import 'package:appflowy/core/notification/folder_notification.dart';
import 'package:appflowy_backend/protobuf/flowy-error/errors.pb.dart';
import 'package:appflowy_backend/protobuf/flowy-folder2/notification.pb.dart';
import 'package:appflowy_backend/protobuf/flowy-folder2/view.pb.dart';
import 'package:appflowy_backend/protobuf/flowy-notification/subject.pb.dart';
import 'package:appflowy_backend/rust_stream.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class FavoriteListener {
  StreamSubscription<SubscribeObject>? _streamSubscription;
  void Function(Either<FlowyError, RepeatedViewPB>, bool)? _favoriteUpdated;
  FolderNotificationParser? _parser;

  void start({
    void Function(Either<FlowyError, RepeatedViewPB>, bool)? favoritesUpdated,
  }) {
    _favoriteUpdated = favoritesUpdated;
    _parser = FolderNotificationParser(
      id: "favorite",
      callback: _observableCallback,
    );
    _streamSubscription =
        RustStreamReceiver.listen((observable) => _parser?.parse(observable));
  }

  void _observableCallback(
    FolderNotification ty,
    Either<Uint8List, FlowyError> result,
  ) {
    switch (ty) {
      case FolderNotification.DidFavoriteView:
        if (_favoriteUpdated != null) {
          result.fold(
            (payload) {
              final favoriteView = RepeatedViewPB.fromBuffer(payload);
              _favoriteUpdated!(right(favoriteView), true);
            },
            (error) => _favoriteUpdated!(left(error), true),
          );
        }
        break;
      case FolderNotification.DidUnFavoriteView:
        if (_favoriteUpdated != null) {
          result.fold(
            (payload) {
              final unfavoriteView = RepeatedViewPB.fromBuffer(payload);
              _favoriteUpdated!(right(unfavoriteView), false);
            },
            (error) => _favoriteUpdated!(left(error), false),
          );
        }
        break;
      default:
        break;
    }
  }

  Future<void> stop() async {
    _parser = null;
    await _streamSubscription?.cancel();
    _favoriteUpdated = null;
  }
}
