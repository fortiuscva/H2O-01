tableextension 50132 "Purch. Cr. Memo Hdr.Ext" extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50100; "Work Order No."; Code[20])
        {
            Caption = 'Work Order No.';
            DataClassification = ToBeClassified;
        }
    }
}
