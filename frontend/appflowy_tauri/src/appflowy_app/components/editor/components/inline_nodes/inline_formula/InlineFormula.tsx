import React, { forwardRef, memo, useCallback, MouseEvent, useRef, useEffect, useState } from 'react';
import { ReactEditor, useSlate } from 'slate-react';
import { Transforms } from 'slate';
import { EditorElementProps, FormulaNode } from '$app/application/document/document.types';
import FormulaLeaf from '$app/components/editor/components/inline_nodes/inline_formula/FormulaLeaf';
import { InlineChromiumBugfix } from '$app/components/editor/components/inline_nodes/InlineChromiumBugfix';
import FormulaEditPopover from '$app/components/editor/components/inline_nodes/inline_formula/FormulaEditPopover';
import { getNodePath, moveCursorToNodeEnd } from '$app/components/editor/components/editor/utils';
import { useElementFocused } from '$app/components/editor/components/inline_nodes/useElementFocused';
import { CustomEditor } from '$app/components/editor/command';

export const InlineFormula = memo(
  forwardRef<HTMLSpanElement, EditorElementProps<FormulaNode>>(({ node, children, ...attributes }, ref) => {
    const editor = useSlate();
    const formula = node.data;
    const focused = useElementFocused(node);

    const anchor = useRef<HTMLSpanElement | null>(null);
    const [openEditPopover, setOpenEditPopover] = useState<boolean>(false);

    const handleClick = useCallback(
      (e: MouseEvent<HTMLSpanElement>) => {
        const target = e.currentTarget;
        const path = getNodePath(editor, target);

        setOpenEditPopover(true);
        ReactEditor.focus(editor);
        Transforms.select(editor, path);
      },
      [editor]
    );

    useEffect(() => {
      if (focused) {
        setOpenEditPopover(true);
      } else {
        setOpenEditPopover(false);
      }
    }, [focused]);

    const handleEditPopoverClose = useCallback(() => {
      setOpenEditPopover(false);
      if (anchor.current === null) {
        return;
      }

      moveCursorToNodeEnd(editor, anchor.current);
    }, [editor]);

    return (
      <>
        <span
          {...attributes}
          ref={(el) => {
            anchor.current = el;
            if (ref) {
              if (typeof ref === 'function') {
                ref(el);
              } else {
                ref.current = el;
              }
            }
          }}
          contentEditable={false}
          onDoubleClick={handleClick}
          onClick={handleClick}
          className={`relative rounded px-1 py-0.5 text-xs ${focused ? 'bg-fill-list-active' : ''}`}
          data-playwright-selected={focused}
        >
          <InlineChromiumBugfix />
          <FormulaLeaf formula={formula}>{children}</FormulaLeaf>
          <InlineChromiumBugfix />
        </span>
        {openEditPopover && (
          <FormulaEditPopover
            defaultText={formula}
            onDone={(newFormula) => {
              if (anchor.current === null || newFormula === formula) return;
              const path = getNodePath(editor, anchor.current);

              // select the node before updating the formula
              Transforms.select(editor, path);
              if (newFormula === '') {
                const point = editor.before(path);

                CustomEditor.deleteFormula(editor);
                setOpenEditPopover(false);
                if (point) {
                  ReactEditor.focus(editor);
                  editor.select(point);
                }

                return;
              } else {
                CustomEditor.updateFormula(editor, newFormula);
                handleEditPopoverClose();
              }
            }}
            anchorEl={anchor.current}
            open={openEditPopover}
            onClose={handleEditPopoverClose}
          />
        )}
      </>
    );
  })
);
