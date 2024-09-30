tableextension 50131 "Purch. Rcpt. Header Ext" extends "Purch. Rcpt. Header"
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
