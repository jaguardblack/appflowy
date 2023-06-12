import { WorkspaceUser } from '../WorkspaceUser';
import { AppLogo } from '../AppLogo';
import { TrashButton } from './TrashButton';
import { NewFolderButton } from './NewFolderButton';
import { NavigationResizer } from './NavigationResizer';
import { IPage } from '$app_reducers/pages/slice';
import { useLocation, useNavigate } from 'react-router-dom';
import React, { useEffect, useRef, useState } from 'react';
import { useAppSelector } from '$app/stores/store';
import { NavItemWrapper } from '$app/components/layout/NavigationPanel/NavItemWrapper';
import {
  ANIMATION_DURATION,
  FOLDER_MARGIN,
  INITIAL_FOLDER_HEIGHT,
  NAV_PANEL_MINIMUM_WIDTH,
  PAGE_ITEM_HEIGHT,
} from '../../_shared/constants';

export const NavigationPanel = ({
  onHideMenuClick,
  menuHidden,
  width,
}: {
  onHideMenuClick: () => void;
  menuHidden: boolean;
  width: number;
}) => {
  const el = useRef<HTMLDivElement>(null);
  const pages = useAppSelector((state) => state.pages);
  const workspace = useAppSelector((state) => state.workspace);
  const [activePageId, setActivePageId] = useState<string>('');
  const currentLocation = useLocation();
  const [maxHeight, setMaxHeight] = useState(0);

  useEffect(() => {
    const { pathname } = currentLocation;
    const parts = pathname.split('/');
    const pageId = parts[parts.length - 1];
    setActivePageId(pageId);
  }, [currentLocation]);

  useEffect(() => {
    /*setTimeout(() => {
      if (!el.current) return;
      if (!activePageId?.length) return;
      const activePage = pagesStore.find((page) => page.id === activePageId);
      if (!activePage) return;

      const folderIndex = foldersStore.findIndex((folder) => folder.id === activePage.parentPageId);
      if (folderIndex === -1) return;

      let height = 0;
      for (let i = 0; i < folderIndex; i++) {
        height += INITIAL_FOLDER_HEIGHT + FOLDER_MARGIN;
        if (foldersStore[i].showPages) {
          height += pagesStore.filter((p) => p.parentPageId === foldersStore[i].id).length * PAGE_ITEM_HEIGHT;
        }
      }

      height += INITIAL_FOLDER_HEIGHT + FOLDER_MARGIN / 2;

      const pageIndex = pagesStore
        .filter((p) => p.parentPageId === foldersStore[folderIndex].id)
        .findIndex((p) => p.id === activePageId);
      for (let i = 0; i <= pageIndex; i++) {
        height += PAGE_ITEM_HEIGHT;
      }

      const elHeight = el.current.getBoundingClientRect().height;
      const scrollTop = el.current.scrollTop;

      if (scrollTop + elHeight < height || scrollTop > height) {
        el.current.scrollTo({ top: height - elHeight, behavior: 'smooth' });
      }
    }, ANIMATION_DURATION);*/
  }, [activePageId]);

  useEffect(() => {
    // setMaxHeight(pagesStore.length * (INITIAL_FOLDER_HEIGHT + FOLDER_MARGIN) + pagesStore.length * PAGE_ITEM_HEIGHT);
    setMaxHeight(pages.length * INITIAL_FOLDER_HEIGHT);
  }, [pages]);

  const scrollDown = () => {
    setTimeout(() => {
      el?.current?.scrollTo({ top: maxHeight, behavior: 'smooth' });
    }, ANIMATION_DURATION);
  };

  return (
    <>
      <div
        className={`absolute inset-0 flex flex-col justify-between bg-surface-1 text-sm`}
        style={{
          transition: `left ${ANIMATION_DURATION}ms ease-out`,
          width: `${width}px`,
          left: `${menuHidden ? -width : 0}px`,
        }}
      >
        <div className={'flex flex-col'}>
          <AppLogo iconToShow={'hide'} onHideMenuClick={onHideMenuClick}></AppLogo>
          <WorkspaceUser></WorkspaceUser>
          <div className={'relative flex flex-1 flex-col'}>
            <div
              className={'flex flex-col overflow-auto px-2'}
              style={{
                maxHeight: 'calc(100vh - 350px)',
              }}
              ref={el}
            >
              <WorkspaceApps pages={pages.filter((p) => p.parentPageId === workspace.id)} />
            </div>
          </div>
        </div>

        <div className={'flex max-h-[215px] flex-col'}>
          <div className={'border-b border-shade-6 px-2 pb-4'}>
            {/*<PluginsButton></PluginsButton>*/}

            <DesignSpec></DesignSpec>
            <AllIcons></AllIcons>
            <TestBackendButton></TestBackendButton>

            {/*Trash Button*/}
            <TrashButton></TrashButton>
          </div>

          {/*New Folder Button*/}
          <NewFolderButton scrollDown={scrollDown}></NewFolderButton>
        </div>
      </div>
      <NavigationResizer minWidth={NAV_PANEL_MINIMUM_WIDTH}></NavigationResizer>
    </>
  );
};

const WorkspaceApps: React.FC<{ pages: IPage[] }> = ({ pages }) => (
  <>
    {pages.map((page, index) => (
      <NavItemWrapper key={index} page={page}></NavItemWrapper>
    ))}
  </>
);

export const TestBackendButton = () => {
  const navigate = useNavigate();
  return (
    <button
      onClick={() => navigate('/page/api-test')}
      className={'flex w-full items-center rounded-lg px-4 py-2 hover:bg-surface-2'}
    >
      API Test
    </button>
  );
};

export const DesignSpec = () => {
  const navigate = useNavigate();

  return (
    <button
      onClick={() => navigate('page/colors')}
      className={'flex w-full items-center rounded-lg px-4 py-2 hover:bg-surface-2'}
    >
      Color Palette
    </button>
  );
};

export const AllIcons = () => {
  const navigate = useNavigate();
  return (
    <button
      onClick={() => navigate('page/all-icons')}
      className={'flex w-full items-center rounded-lg px-4 py-2 hover:bg-surface-2'}
    >
      All Icons
    </button>
  );
};
