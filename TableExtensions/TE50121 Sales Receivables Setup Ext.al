tableextension 50121 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "Archive Batch Invoices"; Boolean)
        {
            Caption = 'Archive Batch Invoices';
            DataClassification = ToBeClassified;
        }
        field(50110; "Auto-Delete Work Order"; boolean)
        {
            Caption = 'Auto-Delete Work Orders';
            DataClassification = ToBeClassified;
        }
        field(50115; "Allow OverWork/Use on Invoices"; boolean)
        {
            Caption = 'Allow OverWork/Use on Invoices';
            DataClassification = ToBeClassified;
            ObsoleteState = Pending;
            ObsoleteReason = 'Not Needed';
        }
        field(50120; "Batch Invoice Testing"; boolean)
        {
            Caption = 'Batch Invoice Testing';
            DataClassification = ToBeClassified;
        }
    }
}
