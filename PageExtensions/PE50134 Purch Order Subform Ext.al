pageextension 50134 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        addafter("Bin Code")
        {
            field("Sales Invoice No."; rec."Sales Invoice No.")
            {
                caption = 'Sales Invoice No.';
                ToolTip = 'Specifies the corresponding Drop Shipment Sales Invoice No.';
                ApplicationArea = All;
                Editable = false;
            }
            field("Sales Invoice Line No."; rec."Sales Invoice Line No.")
            {
                caption = 'Sales Invoice Line No.';
                ToolTip = 'Specifies the corresponding Drop Shipment Sales Invoice Line No.';
                ApplicationArea = All;
                Editable = false;
                BlankZero = true;
            }
        }
    }
}
