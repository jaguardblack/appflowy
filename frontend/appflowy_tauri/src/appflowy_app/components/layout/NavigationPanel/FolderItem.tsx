import { Details2Svg } from '../../_shared/Details2Svg';
import AddSvg from '../../_shared/AddSvg';
import { NavItemOptionsPopup } from './NavItemOptionsPopup';
import { NewPagePopup } from './NewPagePopup';
import { IFolder } from '../../../redux/folders/slice';
import { useFolderEvents } from './FolderItem.hooks';
import { IPage } from '../../../redux/pages/slice';
import { PageItem } from './PageItem';
import { Button } from '../../_shared/Button';
import { RenamePopup } from './RenamePopup';

export const FolderItem = ({
  folder,
  pages,
  onPageClick,
}: {
  folder: IFolder;
  pages: IPage[];
  onPageClick: (page: IPage) => void;
}) => {
  const {
    showPages,
    onFolderNameClick,
    showFolderOptions,
    onFolderOptionsClick,
    showNewPageOptions,
    onNewPageClick,

    showRenamePopup,
    startFolderRename,
    changeFolderTitle,
    closeRenamePopup,
    deleteFolder,
    duplicateFolder,

    onAddNewDocumentPage,
    onAddNewBoardPage,
    onAddNewGridPage,

    closePopup,
  } = useFolderEvents(folder);

  return (
    <div className={'my-2 relative'}>
      <div
        onClick={() => onFolderNameClick()}
        className={'px-4 py-2 cursor-pointer flex items-center justify-between rounded-lg hover:bg-surface-2'}
      >
        <div className={'flex items-center flex-1 min-w-0'}>
          <div className={`mr-2 transition-transform duration-500 ${showPages && 'rotate-180'}`}>
            <img className={''} src={'/images/home/drop_down_show.svg'} alt={''} />
          </div>
          <span className={'whitespace-nowrap overflow-ellipsis overflow-hidden min-w-0 flex-1'}>{folder.title}</span>
        </div>
        <div className={'flex items-center relative'}>
          <Button size={'box-small-transparent'} onClick={() => onFolderOptionsClick()}>
            <Details2Svg></Details2Svg>
          </Button>
          <Button size={'box-small-transparent'} onClick={() => onNewPageClick()}>
            <AddSvg></AddSvg>
          </Button>

          {showFolderOptions && (
            <NavItemOptionsPopup
              onRenameClick={() => startFolderRename()}
              onDeleteClick={() => deleteFolder()}
              onDuplicateClick={() => duplicateFolder()}
              onClose={() => closePopup()}
            ></NavItemOptionsPopup>
          )}
          {showNewPageOptions && (
            <NewPagePopup
              onDocumentClick={() => onAddNewDocumentPage()}
              onBoardClick={() => onAddNewBoardPage()}
              onGridClick={() => onAddNewGridPage()}
              onClose={() => closePopup()}
            ></NewPagePopup>
          )}
        </div>
      </div>
      {showRenamePopup && (
        <RenamePopup
          value={folder.title}
          onChange={(newTitle) => changeFolderTitle(newTitle)}
          onClose={closeRenamePopup}
        ></RenamePopup>
      )}
      {showPages &&
        pages.map((page, index) => <PageItem key={index} page={page} onPageClick={() => onPageClick(page)}></PageItem>)}
    </div>
  );
};
