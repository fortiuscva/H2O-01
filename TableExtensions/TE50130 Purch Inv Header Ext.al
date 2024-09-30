tableextension 50130 "Purch. Inv. Header Ext" extends "Purch. Inv. Header"
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
