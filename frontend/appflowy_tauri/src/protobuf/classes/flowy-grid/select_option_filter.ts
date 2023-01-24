/**
 * Generated by the protoc-gen-ts.  DO NOT EDIT!
 * compiler version: 3.19.4
 * source: select_option_filter.proto
 * git: https://github.com/thesayyn/protoc-gen-ts */
import * as pb_1 from "google-protobuf";
export enum SelectOptionConditionPB {
    OptionIs = 0,
    OptionIsNot = 1,
    OptionIsEmpty = 2,
    OptionIsNotEmpty = 3
}
export class SelectOptionFilterPB extends pb_1.Message {
    #one_of_decls: number[][] = [];
    constructor(data?: any[] | {
        condition?: SelectOptionConditionPB;
        option_ids?: string[];
    }) {
        super();
        pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [2], this.#one_of_decls);
        if (!Array.isArray(data) && typeof data == "object") {
            if ("condition" in data && data.condition != undefined) {
                this.condition = data.condition;
            }
            if ("option_ids" in data && data.option_ids != undefined) {
                this.option_ids = data.option_ids;
            }
        }
    }
    get condition() {
        return pb_1.Message.getFieldWithDefault(this, 1, SelectOptionConditionPB.OptionIs) as SelectOptionConditionPB;
    }
    set condition(value: SelectOptionConditionPB) {
        pb_1.Message.setField(this, 1, value);
    }
    get option_ids() {
        return pb_1.Message.getFieldWithDefault(this, 2, []) as string[];
    }
    set option_ids(value: string[]) {
        pb_1.Message.setField(this, 2, value);
    }
    static fromObject(data: {
        condition?: SelectOptionConditionPB;
        option_ids?: string[];
    }): SelectOptionFilterPB {
        const message = new SelectOptionFilterPB({});
        if (data.condition != null) {
            message.condition = data.condition;
        }
        if (data.option_ids != null) {
            message.option_ids = data.option_ids;
        }
        return message;
    }
    toObject() {
        const data: {
            condition?: SelectOptionConditionPB;
            option_ids?: string[];
        } = {};
        if (this.condition != null) {
            data.condition = this.condition;
        }
        if (this.option_ids != null) {
            data.option_ids = this.option_ids;
        }
        return data;
    }
    serialize(): Uint8Array;
    serialize(w: pb_1.BinaryWriter): void;
    serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
        const writer = w || new pb_1.BinaryWriter();
        if (this.condition != SelectOptionConditionPB.OptionIs)
            writer.writeEnum(1, this.condition);
        if (this.option_ids.length)
            writer.writeRepeatedString(2, this.option_ids);
        if (!w)
            return writer.getResultBuffer();
    }
    static deserialize(bytes: Uint8Array | pb_1.BinaryReader): SelectOptionFilterPB {
        const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new SelectOptionFilterPB();
        while (reader.nextField()) {
            if (reader.isEndGroup())
                break;
            switch (reader.getFieldNumber()) {
                case 1:
                    message.condition = reader.readEnum();
                    break;
                case 2:
                    pb_1.Message.addToRepeatedField(message, 2, reader.readString());
                    break;
                default: reader.skipField();
            }
        }
        return message;
    }
    serializeBinary(): Uint8Array {
        return this.serialize();
    }
    static deserializeBinary(bytes: Uint8Array): SelectOptionFilterPB {
        return SelectOptionFilterPB.deserialize(bytes);
    }
}
