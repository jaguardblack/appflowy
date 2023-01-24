/**
 * Generated by the protoc-gen-ts.  DO NOT EDIT!
 * compiler version: 3.19.4
 * source: checkbox_filter.proto
 * git: https://github.com/thesayyn/protoc-gen-ts */
import * as pb_1 from "google-protobuf";
export enum CheckboxFilterConditionPB {
    IsChecked = 0,
    IsUnChecked = 1
}
export class CheckboxFilterPB extends pb_1.Message {
    #one_of_decls: number[][] = [];
    constructor(data?: any[] | {
        condition?: CheckboxFilterConditionPB;
    }) {
        super();
        pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [], this.#one_of_decls);
        if (!Array.isArray(data) && typeof data == "object") {
            if ("condition" in data && data.condition != undefined) {
                this.condition = data.condition;
            }
        }
    }
    get condition() {
        return pb_1.Message.getFieldWithDefault(this, 1, CheckboxFilterConditionPB.IsChecked) as CheckboxFilterConditionPB;
    }
    set condition(value: CheckboxFilterConditionPB) {
        pb_1.Message.setField(this, 1, value);
    }
    static fromObject(data: {
        condition?: CheckboxFilterConditionPB;
    }): CheckboxFilterPB {
        const message = new CheckboxFilterPB({});
        if (data.condition != null) {
            message.condition = data.condition;
        }
        return message;
    }
    toObject() {
        const data: {
            condition?: CheckboxFilterConditionPB;
        } = {};
        if (this.condition != null) {
            data.condition = this.condition;
        }
        return data;
    }
    serialize(): Uint8Array;
    serialize(w: pb_1.BinaryWriter): void;
    serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
        const writer = w || new pb_1.BinaryWriter();
        if (this.condition != CheckboxFilterConditionPB.IsChecked)
            writer.writeEnum(1, this.condition);
        if (!w)
            return writer.getResultBuffer();
    }
    static deserialize(bytes: Uint8Array | pb_1.BinaryReader): CheckboxFilterPB {
        const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new CheckboxFilterPB();
        while (reader.nextField()) {
            if (reader.isEndGroup())
                break;
            switch (reader.getFieldNumber()) {
                case 1:
                    message.condition = reader.readEnum();
                    break;
                default: reader.skipField();
            }
        }
        return message;
    }
    serializeBinary(): Uint8Array {
        return this.serialize();
    }
    static deserializeBinary(bytes: Uint8Array): CheckboxFilterPB {
        return CheckboxFilterPB.deserialize(bytes);
    }
}
