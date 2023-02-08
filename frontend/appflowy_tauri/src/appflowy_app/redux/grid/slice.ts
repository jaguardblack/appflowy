import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { nanoid } from 'nanoid';

// eslint-disable-next-line no-shadow
export enum FieldType {
  Text = 'text',
  Numbers = 'numbers',
  Date = 'date',
  Select = 'select',
  MultiSelect = 'multiselect',
  Checklist = 'checklist  ',
  URL = 'url',
}
const initialState = {
  title: 'My plans on the week',
  fields: [
    {
      fieldId: '1',
      fieldType: FieldType.Text,
      fieldOptions: {},
      name: 'Todo',
    },
    {
      fieldId: '2',
      fieldType: FieldType.Text,
      fieldOptions: [],
      name: 'Status',
    },
    {
      fieldId: '3',
      fieldType: FieldType.Text,
      fieldOptions: [],
      name: 'Description',
    },
  ],
  rows: [
    {
      rowId: '1',
      values: [
        {
          fieldId: '1',
          value: 'Name 1',
          cellId: '1',
        },
        {
          fieldId: '2',
          value: 'Status 1',
          cellId: '2',
        },
        {
          fieldId: '3',
          value: 'Description 1',
          cellId: '3',
        },
      ],
    },
    {
      rowId: '2',
      values: [
        {
          fieldId: '1',
          value: 'Name 2',
          cellId: '4',
        },
        {
          fieldId: '2',
          value: 'Status 2',
          cellId: '5',
        },
        {
          fieldId: '3',
          value: 'Description 2',
          cellId: '6',
        },
      ],
    },
  ],
};

export type field = {
  fieldId: string;
  fieldType: FieldType;
  fieldOptions: any;
  name: string;
};

export const gridSlice = createSlice({
  name: 'grid',
  initialState: initialState,
  reducers: {
    updateGridTitle: (state, action: PayloadAction<{ title: string }>) => {
      state.title = action.payload.title;
    },

    addField: (state, action: PayloadAction<{ field: field }>) => {
      state.fields.push(action.payload.field);

      state.rows.map((row) => {
        row.values.push({
          fieldId: action.payload.field.fieldId,
          value: '',
          cellId: nanoid(),
        });
      });
    },

    addRow: (state) => {
      const newRow = {
        rowId: nanoid(),
        values: state.fields.map((f) => ({
          fieldId: f.fieldId,
          value: '',
          cellId: nanoid(),
        })),
      };

      state.rows.push(newRow);
    },

    updateRowValue: (state, action: PayloadAction<{ rowId: string; cellId: string; value: string }>) => {
      console.log('updateRowValue', action.payload);
      const row = state.rows.find((r) => r.rowId === action.payload.rowId);

      if (row) {
        const cell = row.values.find((c) => c.cellId === action.payload.cellId);
        if (cell) {
          cell.value = action.payload.value;
        }
      }
    },
  },
});

export const gridActions = gridSlice.actions;
