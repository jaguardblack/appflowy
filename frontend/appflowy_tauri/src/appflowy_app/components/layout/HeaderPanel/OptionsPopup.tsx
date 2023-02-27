import { IPopupItem, Popup } from '../../_shared/Popup';
import { CloseSvg } from '../../_shared/svg/CloseSvg';

export const OptionsPopup = ({ onSignOutClick, onClose }: { onSignOutClick: () => void; onClose: () => void }) => {
  const items: IPopupItem[] = [
    {
      title: 'Sign out',
      icon: (
        <i className={'block h-5 w-5 flex-shrink-0'}>
          <CloseSvg></CloseSvg>
        </i>
      ),
      onClick: onSignOutClick,
    },
  ];
  return (
    <Popup className={'absolute top-full right-0 z-10 whitespace-nowrap'} items={items} onOutsideClick={onClose}></Popup>
  );
};
