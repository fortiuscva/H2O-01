pageextension 50103 "Item Ledger Entries Ext" extends "Item Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field(Meter; rec.Meter)
            {
                caption = 'Meter';
                ToolTip = 'Specifies whether the Item Ledger Entry is the sale of a Meter.';
                ApplicationArea = All;
            }
            field("Meter Created"; rec."Meter Created")
            {
                caption = 'Meter Created';
                ToolTip = 'Specifies whether the Item has been created as a Meter.';
                ApplicationArea = All;
            }
            field("Meter No."; rec."Meter No.")
            {
                caption = 'Meter No.';
                ToolTip = 'The Meter No. if the item has been created into a Meter.';
                ApplicationArea = All;
            }
        }
        addafter("Source No.")
        {
            field("Source Sub No."; rec."Source Sub No.")
            {
                caption = 'Source Sub No.';
                ToolTip = 'This should only be non-blank on sales transactions, it specified te Ship-to Code of the corresponcind Souce No. customer.';
                ApplicationArea = All;
            }
        }
    }
}
