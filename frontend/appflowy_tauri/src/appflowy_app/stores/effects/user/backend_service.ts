import { nanoid } from '@reduxjs/toolkit';
import {
  UserEventGetUserProfile,
  UserEventSignIn,
  UserEventSignOut,
  UserEventSignUp,
  UserEventUpdateUserProfile,
} from '../../../../services/backend/events/flowy-user';
import { SignInPayloadPB, SignUpPayloadPB } from '../../../../services/backend/models/flowy-user/auth';
import { UpdateUserProfilePayloadPB } from '../../../../services/backend/models/flowy-user/user_profile';
import { WorkspaceIdPB, CreateWorkspacePayloadPB } from '../../../../services/backend/models/flowy-folder/workspace';
import {
  FolderEventCreateWorkspace,
  FolderEventOpenWorkspace,
  FolderEventReadWorkspaces,
} from '../../../../services/backend/events/flowy-folder';

export class UserBackendService {
  constructor(public readonly userId: string) {}

  getUserProfile = () => {
    return UserEventGetUserProfile();
  };

  updateUserProfile = (params: { name?: string; password?: string; email?: string; openAIKey?: string }) => {
    const payload = UpdateUserProfilePayloadPB.fromObject({ id: this.userId });

    if (params.name !== undefined) {
      payload.name = params.name;
    }
    if (params.password !== undefined) {
      payload.password = params.password;
    }
    if (params.email !== undefined) {
      payload.email = params.email;
    }
    // if (params.openAIKey !== undefined) {
    // }
    return UserEventUpdateUserProfile(payload);
  };

  getWorkspaces = () => {
    const payload = WorkspaceIdPB.fromObject({});
    return FolderEventReadWorkspaces(payload);
  };

  openWorkspace = (workspaceId: string) => {
    const payload = WorkspaceIdPB.fromObject({ value: workspaceId });
    return FolderEventOpenWorkspace(payload);
  };

  createWorkspace = (params: { name: string; desc: string }) => {
    const payload = CreateWorkspacePayloadPB.fromObject({ name: params.name, desc: params.desc });
    return FolderEventCreateWorkspace(payload);
  };

  signOut = () => {
    return UserEventSignOut();
  };
}

export class AuthBackendService {
  signIn = (params: { email: string; password: string }) => {
    const payload = SignInPayloadPB.fromObject({ email: params.email, password: params.password });
    return UserEventSignIn(payload);
  };

  signUp = (params: { name: string; email: string; password: string }) => {
    const payload = SignUpPayloadPB.fromObject({ name: params.name, email: params.email, password: params.password });
    return UserEventSignUp(payload);
  };

  signOut = () => {
    return UserEventSignOut();
  };

  autoSignUp = () => {
    const password = 'AppFlowy123@';
    const email = nanoid(4) + '@appflowy.io';
    return this.signUp({ name: 'Me', email: email, password: password });
  };
}
