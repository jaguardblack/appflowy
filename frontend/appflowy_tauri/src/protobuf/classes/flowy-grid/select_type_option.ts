/**
 * Generated by the protoc-gen-ts.  DO NOT EDIT!
 * compiler version: 3.19.4
 * source: select_type_option.proto
 * git: https://github.com/thesayyn/protoc-gen-ts */
import * as dependency_1 from "./cell_entities";
import * as pb_1 from "google-protobuf";
export enum SelectOptionColorPB {
    Purple = 0,
    Pink = 1,
    LightPink = 2,
    Orange = 3,
    Yellow = 4,
    Lime = 5,
    Green = 6,
    Aqua = 7,
    Blue = 8
}
export class SelectOptionPB extends pb_1.Message {
    #one_of_decls: number[][] = [];
    constructor(data?: any[] | {
        id?: string;
        name?: string;
        color?: SelectOptionColorPB;
    }) {
        super();
        pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [], this.#one_of_decls);
        if (!Array.isArray(data) && typeof data == "object") {
            if ("id" in data && data.id != undefined) {
                this.id = data.id;
            }
            if ("name" in data && data.name != undefined) {
                this.name = data.name;
            }
            if ("color" in data && data.color != undefined) {
                this.color = data.color;
            }
        }
    }
    get id() {
        return pb_1.Message.getFieldWithDefault(this, 1, "") as string;
    }
    set id(value: string) {
        pb_1.Message.setField(this, 1, value);
    }
    get name() {
        return pb_1.Message.getFieldWithDefault(this, 2, "") as string;
    }
    set name(value: string) {
        pb_1.Message.setField(this, 2, value);
    }
    get color() {
        return pb_1.Message.getFieldWithDefault(this, 3, SelectOptionColorPB.Purple) as SelectOptionColorPB;
    }
    set color(value: SelectOptionColorPB) {
        pb_1.Message.setField(this, 3, value);
    }
    static fromObject(data: {
        id?: string;
        name?: string;
        color?: SelectOptionColorPB;
    }): SelectOptionPB {
        const message = new SelectOptionPB({});
        if (data.id != null) {
            message.id = data.id;
        }
        if (data.name != null) {
            message.name = data.name;
        }
        if (data.color != null) {
            message.color = data.color;
        }
        return message;
    }
    toObject() {
        const data: {
            id?: string;
            name?: string;
            color?: SelectOptionColorPB;
        } = {};
        if (this.id != null) {
            data.id = this.id;
        }
        if (this.name != null) {
            data.name = this.name;
        }
        if (this.color != null) {
            data.color = this.color;
        }
        return data;
    }
    serialize(): Uint8Array;
    serialize(w: pb_1.BinaryWriter): void;
    serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
        const writer = w || new pb_1.BinaryWriter();
        if (this.id.length)
            writer.writeString(1, this.id);
        if (this.name.length)
            writer.writeString(2, this.name);
        if (this.color != SelectOptionColorPB.Purple)
            writer.writeEnum(3, this.color);
        if (!w)
            return writer.getResultBuffer();
    }
    static deserialize(bytes: Uint8Array | pb_1.BinaryReader): SelectOptionPB {
        const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new SelectOptionPB();
        while (reader.nextField()) {
            if (reader.isEndGroup())
                break;
            switch (reader.getFieldNumber()) {
                case 1:
                    message.id = reader.readString();
                    break;
                case 2:
                    message.name = reader.readString();
                    break;
                case 3:
                    message.color = reader.readEnum();
                    break;
                default: reader.skipField();
            }
        }
        return message;
    }
    serializeBinary(): Uint8Array {
        return this.serialize();
    }
    static deserializeBinary(bytes: Uint8Array): SelectOptionPB {
        return SelectOptionPB.deserialize(bytes);
    }
}
export class SelectOptionCellChangesetPB extends pb_1.Message {
    #one_of_decls: number[][] = [];
    constructor(data?: any[] | {
        cell_identifier?: dependency_1.CellPathPB;
        insert_option_ids?: string[];
        delete_option_ids?: string[];
    }) {
        super();
        pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [2, 3], this.#one_of_decls);
        if (!Array.isArray(data) && typeof data == "object") {
            if ("cell_identifier" in data && data.cell_identifier != undefined) {
                this.cell_identifier = data.cell_identifier;
            }
            if ("insert_option_ids" in data && data.insert_option_ids != undefined) {
                this.insert_option_ids = data.insert_option_ids;
            }
            if ("delete_option_ids" in data && data.delete_option_ids != undefined) {
                this.delete_option_ids = data.delete_option_ids;
            }
        }
    }
    get cell_identifier() {
        return pb_1.Message.getWrapperField(this, dependency_1.CellPathPB, 1) as dependency_1.CellPathPB;
    }
    set cell_identifier(value: dependency_1.CellPathPB) {
        pb_1.Message.setWrapperField(this, 1, value);
    }
    get has_cell_identifier() {
        return pb_1.Message.getField(this, 1) != null;
    }
    get insert_option_ids() {
        return pb_1.Message.getFieldWithDefault(this, 2, []) as string[];
    }
    set insert_option_ids(value: string[]) {
        pb_1.Message.setField(this, 2, value);
    }
    get delete_option_ids() {
        return pb_1.Message.getFieldWithDefault(this, 3, []) as string[];
    }
    set delete_option_ids(value: string[]) {
        pb_1.Message.setField(this, 3, value);
    }
    static fromObject(data: {
        cell_identifier?: ReturnType<typeof dependency_1.CellPathPB.prototype.toObject>;
        insert_option_ids?: string[];
        delete_option_ids?: string[];
    }): SelectOptionCellChangesetPB {
        const message = new SelectOptionCellChangesetPB({});
        if (data.cell_identifier != null) {
            message.cell_identifier = dependency_1.CellPathPB.fromObject(data.cell_identifier);
        }
        if (data.insert_option_ids != null) {
            message.insert_option_ids = data.insert_option_ids;
        }
        if (data.delete_option_ids != null) {
            message.delete_option_ids = data.delete_option_ids;
        }
        return message;
    }
    toObject() {
        const data: {
            cell_identifier?: ReturnType<typeof dependency_1.CellPathPB.prototype.toObject>;
            insert_option_ids?: string[];
            delete_option_ids?: string[];
        } = {};
        if (this.cell_identifier != null) {
            data.cell_identifier = this.cell_identifier.toObject();
        }
        if (this.insert_option_ids != null) {
            data.insert_option_ids = this.insert_option_ids;
        }
        if (this.delete_option_ids != null) {
            data.delete_option_ids = this.delete_option_ids;
        }
        return data;
    }
    serialize(): Uint8Array;
    serialize(w: pb_1.BinaryWriter): void;
    serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
        const writer = w || new pb_1.BinaryWriter();
        if (this.has_cell_identifier)
            writer.writeMessage(1, this.cell_identifier, () => this.cell_identifier.serialize(writer));
        if (this.insert_option_ids.length)
            writer.writeRepeatedString(2, this.insert_option_ids);
        if (this.delete_option_ids.length)
            writer.writeRepeatedString(3, this.delete_option_ids);
        if (!w)
            return writer.getResultBuffer();
    }
    static deserialize(bytes: Uint8Array | pb_1.BinaryReader): SelectOptionCellChangesetPB {
        const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new SelectOptionCellChangesetPB();
        while (reader.nextField()) {
            if (reader.isEndGroup())
                break;
            switch (reader.getFieldNumber()) {
                case 1:
                    reader.readMessage(message.cell_identifier, () => message.cell_identifier = dependency_1.CellPathPB.deserialize(reader));
                    break;
                case 2:
                    pb_1.Message.addToRepeatedField(message, 2, reader.readString());
                    break;
                case 3:
                    pb_1.Message.addToRepeatedField(message, 3, reader.readString());
                    break;
                default: reader.skipField();
            }
        }
        return message;
    }
    serializeBinary(): Uint8Array {
        return this.serialize();
    }
    static deserializeBinary(bytes: Uint8Array): SelectOptionCellChangesetPB {
        return SelectOptionCellChangesetPB.deserialize(bytes);
    }
}
export class SelectOptionCellDataPB extends pb_1.Message {
    #one_of_decls: number[][] = [];
    constructor(data?: any[] | {
        options?: SelectOptionPB[];
        select_options?: SelectOptionPB[];
    }) {
        super();
        pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [1, 2], this.#one_of_decls);
        if (!Array.isArray(data) && typeof data == "object") {
            if ("options" in data && data.options != undefined) {
                this.options = data.options;
            }
            if ("select_options" in data && data.select_options != undefined) {
                this.select_options = data.select_options;
            }
        }
    }
    get options() {
        return pb_1.Message.getRepeatedWrapperField(this, SelectOptionPB, 1) as SelectOptionPB[];
    }
    set options(value: SelectOptionPB[]) {
        pb_1.Message.setRepeatedWrapperField(this, 1, value);
    }
    get select_options() {
        return pb_1.Message.getRepeatedWrapperField(this, SelectOptionPB, 2) as SelectOptionPB[];
    }
    set select_options(value: SelectOptionPB[]) {
        pb_1.Message.setRepeatedWrapperField(this, 2, value);
    }
    static fromObject(data: {
        options?: ReturnType<typeof SelectOptionPB.prototype.toObject>[];
        select_options?: ReturnType<typeof SelectOptionPB.prototype.toObject>[];
    }): SelectOptionCellDataPB {
        const message = new SelectOptionCellDataPB({});
        if (data.options != null) {
            message.options = data.options.map(item => SelectOptionPB.fromObject(item));
        }
        if (data.select_options != null) {
            message.select_options = data.select_options.map(item => SelectOptionPB.fromObject(item));
        }
        return message;
    }
    toObject() {
        const data: {
            options?: ReturnType<typeof SelectOptionPB.prototype.toObject>[];
            select_options?: ReturnType<typeof SelectOptionPB.prototype.toObject>[];
        } = {};
        if (this.options != null) {
            data.options = this.options.map((item: SelectOptionPB) => item.toObject());
        }
        if (this.select_options != null) {
            data.select_options = this.select_options.map((item: SelectOptionPB) => item.toObject());
        }
        return data;
    }
    serialize(): Uint8Array;
    serialize(w: pb_1.BinaryWriter): void;
    serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
        const writer = w || new pb_1.BinaryWriter();
        if (this.options.length)
            writer.writeRepeatedMessage(1, this.options, (item: SelectOptionPB) => item.serialize(writer));
        if (this.select_options.length)
            writer.writeRepeatedMessage(2, this.select_options, (item: SelectOptionPB) => item.serialize(writer));
        if (!w)
            return writer.getResultBuffer();
    }
    static deserialize(bytes: Uint8Array | pb_1.BinaryReader): SelectOptionCellDataPB {
        const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new SelectOptionCellDataPB();
        while (reader.nextField()) {
            if (reader.isEndGroup())
                break;
            switch (reader.getFieldNumber()) {
                case 1:
                    reader.readMessage(message.options, () => pb_1.Message.addToRepeatedWrapperField(message, 1, SelectOptionPB.deserialize(reader), SelectOptionPB));
                    break;
                case 2:
                    reader.readMessage(message.select_options, () => pb_1.Message.addToRepeatedWrapperField(message, 2, SelectOptionPB.deserialize(reader), SelectOptionPB));
                    break;
                default: reader.skipField();
            }
        }
        return message;
    }
    serializeBinary(): Uint8Array {
        return this.serialize();
    }
    static deserializeBinary(bytes: Uint8Array): SelectOptionCellDataPB {
        return SelectOptionCellDataPB.deserialize(bytes);
    }
}
export class SelectOptionChangesetPB extends pb_1.Message {
    #one_of_decls: number[][] = [];
    constructor(data?: any[] | {
        cell_identifier?: dependency_1.CellPathPB;
        insert_options?: SelectOptionPB[];
        update_options?: SelectOptionPB[];
        delete_options?: SelectOptionPB[];
    }) {
        super();
        pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [2, 3, 4], this.#one_of_decls);
        if (!Array.isArray(data) && typeof data == "object") {
            if ("cell_identifier" in data && data.cell_identifier != undefined) {
                this.cell_identifier = data.cell_identifier;
            }
            if ("insert_options" in data && data.insert_options != undefined) {
                this.insert_options = data.insert_options;
            }
            if ("update_options" in data && data.update_options != undefined) {
                this.update_options = data.update_options;
            }
            if ("delete_options" in data && data.delete_options != undefined) {
                this.delete_options = data.delete_options;
            }
        }
    }
    get cell_identifier() {
        return pb_1.Message.getWrapperField(this, dependency_1.CellPathPB, 1) as dependency_1.CellPathPB;
    }
    set cell_identifier(value: dependency_1.CellPathPB) {
        pb_1.Message.setWrapperField(this, 1, value);
    }
    get has_cell_identifier() {
        return pb_1.Message.getField(this, 1) != null;
    }
    get insert_options() {
        return pb_1.Message.getRepeatedWrapperField(this, SelectOptionPB, 2) as SelectOptionPB[];
    }
    set insert_options(value: SelectOptionPB[]) {
        pb_1.Message.setRepeatedWrapperField(this, 2, value);
    }
    get update_options() {
        return pb_1.Message.getRepeatedWrapperField(this, SelectOptionPB, 3) as SelectOptionPB[];
    }
    set update_options(value: SelectOptionPB[]) {
        pb_1.Message.setRepeatedWrapperField(this, 3, value);
    }
    get delete_options() {
        return pb_1.Message.getRepeatedWrapperField(this, SelectOptionPB, 4) as SelectOptionPB[];
    }
    set delete_options(value: SelectOptionPB[]) {
        pb_1.Message.setRepeatedWrapperField(this, 4, value);
    }
    static fromObject(data: {
        cell_identifier?: ReturnType<typeof dependency_1.CellPathPB.prototype.toObject>;
        insert_options?: ReturnType<typeof SelectOptionPB.prototype.toObject>[];
        update_options?: ReturnType<typeof SelectOptionPB.prototype.toObject>[];
        delete_options?: ReturnType<typeof SelectOptionPB.prototype.toObject>[];
    }): SelectOptionChangesetPB {
        const message = new SelectOptionChangesetPB({});
        if (data.cell_identifier != null) {
            message.cell_identifier = dependency_1.CellPathPB.fromObject(data.cell_identifier);
        }
        if (data.insert_options != null) {
            message.insert_options = data.insert_options.map(item => SelectOptionPB.fromObject(item));
        }
        if (data.update_options != null) {
            message.update_options = data.update_options.map(item => SelectOptionPB.fromObject(item));
        }
        if (data.delete_options != null) {
            message.delete_options = data.delete_options.map(item => SelectOptionPB.fromObject(item));
        }
        return message;
    }
    toObject() {
        const data: {
            cell_identifier?: ReturnType<typeof dependency_1.CellPathPB.prototype.toObject>;
            insert_options?: ReturnType<typeof SelectOptionPB.prototype.toObject>[];
            update_options?: ReturnType<typeof SelectOptionPB.prototype.toObject>[];
            delete_options?: ReturnType<typeof SelectOptionPB.prototype.toObject>[];
        } = {};
        if (this.cell_identifier != null) {
            data.cell_identifier = this.cell_identifier.toObject();
        }
        if (this.insert_options != null) {
            data.insert_options = this.insert_options.map((item: SelectOptionPB) => item.toObject());
        }
        if (this.update_options != null) {
            data.update_options = this.update_options.map((item: SelectOptionPB) => item.toObject());
        }
        if (this.delete_options != null) {
            data.delete_options = this.delete_options.map((item: SelectOptionPB) => item.toObject());
        }
        return data;
    }
    serialize(): Uint8Array;
    serialize(w: pb_1.BinaryWriter): void;
    serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
        const writer = w || new pb_1.BinaryWriter();
        if (this.has_cell_identifier)
            writer.writeMessage(1, this.cell_identifier, () => this.cell_identifier.serialize(writer));
        if (this.insert_options.length)
            writer.writeRepeatedMessage(2, this.insert_options, (item: SelectOptionPB) => item.serialize(writer));
        if (this.update_options.length)
            writer.writeRepeatedMessage(3, this.update_options, (item: SelectOptionPB) => item.serialize(writer));
        if (this.delete_options.length)
            writer.writeRepeatedMessage(4, this.delete_options, (item: SelectOptionPB) => item.serialize(writer));
        if (!w)
            return writer.getResultBuffer();
    }
    static deserialize(bytes: Uint8Array | pb_1.BinaryReader): SelectOptionChangesetPB {
        const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new SelectOptionChangesetPB();
        while (reader.nextField()) {
            if (reader.isEndGroup())
                break;
            switch (reader.getFieldNumber()) {
                case 1:
                    reader.readMessage(message.cell_identifier, () => message.cell_identifier = dependency_1.CellPathPB.deserialize(reader));
                    break;
                case 2:
                    reader.readMessage(message.insert_options, () => pb_1.Message.addToRepeatedWrapperField(message, 2, SelectOptionPB.deserialize(reader), SelectOptionPB));
                    break;
                case 3:
                    reader.readMessage(message.update_options, () => pb_1.Message.addToRepeatedWrapperField(message, 3, SelectOptionPB.deserialize(reader), SelectOptionPB));
                    break;
                case 4:
                    reader.readMessage(message.delete_options, () => pb_1.Message.addToRepeatedWrapperField(message, 4, SelectOptionPB.deserialize(reader), SelectOptionPB));
                    break;
                default: reader.skipField();
            }
        }
        return message;
    }
    serializeBinary(): Uint8Array {
        return this.serialize();
    }
    static deserializeBinary(bytes: Uint8Array): SelectOptionChangesetPB {
        return SelectOptionChangesetPB.deserialize(bytes);
    }
}
