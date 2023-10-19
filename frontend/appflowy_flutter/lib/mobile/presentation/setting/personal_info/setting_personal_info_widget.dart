import 'package:appflowy/env/env.dart';
import 'package:appflowy/startup/startup.dart';
import 'package:appflowy/workspace/application/user/prelude.dart';
import 'package:appflowy_backend/protobuf/flowy-user/protobuf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/widgets.dart';
import 'personal_info.dart';

class SettingPersonalInfoWidget extends StatelessWidget {
  const SettingPersonalInfoWidget({
    super.key,
    required this.userProfile,
  });

  final UserProfilePB? userProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<SettingsUserViewBloc>(
      create: (context) => getIt<SettingsUserViewBloc>(
        param1: userProfile,
      )..add(const SettingsUserEvent.initial()),
      child: BlocSelector<SettingsUserViewBloc, SettingsUserState, String>(
        selector: (state) => state.userProfile.name,
        builder: (context, userName) {
          return MobileSettingGroupWidget(
            groupTitle: 'Personal Information',
            settingItemWidgets: [
              MobileSettingItemWidget(
                name: userName,
                subtitle: isCloudEnabled && userProfile != null
                    ? Text(
                        userProfile!.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      )
                    : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    // avoid bottom sheet overflow from resizing when keyboard appears
                    isScrollControlled: true,
                    builder: (_) {
                      return EditUsernameBottomSheet(
                        context,
                        userName: userName,
                        onSubmitted: (value) {
                          context.read<SettingsUserViewBloc>().add(
                                SettingsUserEvent.updateUserName(
                                  value,
                                ),
                              );
                        },
                      );
                    },
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
