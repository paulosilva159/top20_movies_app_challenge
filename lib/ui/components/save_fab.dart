import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class SaveFAB extends StatelessWidget {
  const SaveFAB({@required this.isToSave, @required this.onSaveTap})
      : assert(isToSave != null),
        assert(onSaveTap != null);

  final bool isToSave;
  final VoidCallback onSaveTap;

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
        onPressed: isToSave ? onSaveTap : null,
        label: Text(isToSave
            ? S.of(context).wantToSaveListMessage
            : S.of(context).listSavedMessage),
        icon: isToSave
            ? null
            : const Icon(
                Icons.check_circle,
                color: Colors.greenAccent,
              ),
      );
}
