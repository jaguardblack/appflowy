import { Editor } from 'slate';

export enum BlockType {
  PageBlock = 'page',
  HeadingBlock = 'heading',
  TextBlock = 'text',
  TodoListBlock = 'todo_list',
  BulletedListBlock = 'bulleted_list',
  NumberedListBlock = 'numbered_list',
  ToggleListBlock = 'toggle_list',
  CodeBlock = 'code',
  EmbedBlock = 'embed',
  QuoteBlock = 'quote',
  CalloutBlock = 'callout',
  DividerBlock = 'divider',
  MediaBlock = 'media',
  TableBlock = 'table',
  ColumnBlock = 'column',
}

export interface HeadingBlockData extends TextBlockData {
  level: number;
}

export interface TodoListBlockData extends TextBlockData {
  checked: boolean;
}

export interface BulletListBlockData extends TextBlockData {
  format: 'default' | 'circle' | 'square' | 'disc';
}

export interface NumberedListBlockData extends TextBlockData {
  format: 'default' | 'numbers' | 'letters' | 'roman_numerals';
}

export interface ToggleListBlockData extends TextBlockData {
  collapsed: boolean;
}

export interface QuoteBlockData extends TextBlockData {
  size: 'default' | 'large';
}

export interface TextBlockData {
  delta: TextDelta[];
}

export type PageBlockData = TextBlockData;

export type BlockData<Type> = Type extends BlockType.HeadingBlock
  ? HeadingBlockData
  : Type extends BlockType.PageBlock
  ? PageBlockData
  : Type extends BlockType.TodoListBlock
  ? TodoListBlockData
  : Type extends BlockType.QuoteBlock
  ? QuoteBlockData
  : Type extends BlockType.BulletedListBlock
  ? BulletListBlockData
  : Type extends BlockType.NumberedListBlock
  ? NumberedListBlockData
  : Type extends BlockType.ToggleListBlock
  ? ToggleListBlockData
  : TextBlockData;

export interface NestedBlock<Type = any> {
  id: string;
  type: BlockType;
  data: BlockData<Type>;
  parent: string | null;
  children: string;
}
export interface TextDelta {
  insert: string;
  attributes?: Record<string, string | boolean>;
}

export enum BlockActionType {
  Insert = 0,
  Update = 1,
  Delete = 2,
  Move = 3,
}

export interface DeltaItem {
  action: 'inserted' | 'removed' | 'updated';
  payload: {
    id: string;
    value?: NestedBlock | string[];
  };
}

export type Node = NestedBlock;

export interface SelectionPoint {
  path: [number, number];
  offset: number;
}

export interface TextSelection {
  anchor: SelectionPoint;
  focus: SelectionPoint;
}

export interface DocumentData {
  rootId: string;
  // map of block id to block
  nodes: Record<string, Node>;
  // map of block id to children block ids
  children: Record<string, string[]>;
}
export interface DocumentState {
  // map of block id to block
  nodes: Record<string, Node>;
  // map of block id to children block ids
  children: Record<string, string[]>;
  // selected block ids
  selections: string[];
  // map of block id to text selection
  textSelections: Record<string, TextSelection>;
}

export enum ChangeType {
  BlockInsert,
  BlockUpdate,
  BlockDelete,
  ChildrenMapInsert,
  ChildrenMapUpdate,
  ChildrenMapDelete,
}

export interface BlockPBValue {
  id: string;
  ty: string;
  parent: string;
  children: string;
  data: string;
}

export type TextBlockKeyEventHandlerParams = [React.KeyboardEvent<HTMLDivElement>, Editor];
