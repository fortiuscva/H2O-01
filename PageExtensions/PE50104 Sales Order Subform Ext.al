pageextension 50104 "Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        modify(Type)
        {
            ApplicationArea = All;
        }
        modify(FilteredTypeField)
        {
            Visible = false;
        }
        addbefore("Location Code")
        {
            field(Rental; rec.Rental)
            {
                caption = 'Rental';
                ToolTip = 'Specifies whether or not the resource is a rental.';
                ApplicationArea = All;
            }
            field("Meter Activity Code"; rec."Meter Activity Code")
            {
                caption = 'Meter Activity Type';
                ToolTip = 'Specifies the value of the Meter Activity Type field.';
                ApplicationArea = All;
            }
            field("Meter Serial No."; rec."Meter Serial No.")
            {
                caption = 'Meter Serial No.';
                ToolTip = 'Specifies the value of the Meter Serial No. field.';
                ApplicationArea = All;
            }
            field("Original Documet No."; rec."Original Document No.")
            {
                caption = 'Original Document No.';
                Tooltip = 'Specifies the original Work Order No.';
                ApplicationArea = all;
            }
            field("Original Line No."; rec."Original Line No.")
            {
                caption = 'Original Document Line No.';
                Tooltip = 'Specifies the original Work Order Line No.';
                ApplicationArea = all;
            }
            field("Start Time"; rec."Start Time")
            {
                caption = 'Work Order Start Time';
                Tooltip = 'Specifies the Start Time of the work order line.';
                ApplicationArea = all;
            }
            field("End Time"; rec."End Time")
            {
                caption = 'Work Order End Time';
                Tooltip = 'Specifies the End Time of the work order line.';
                ApplicationArea = all;
            }
            field("WO Supervisor"; rec."WO Supervisor")
            {
                caption = 'Work Order Wupervisor';
                Tooltip = 'Specifies the technician''s supervisor for THIS work order.';
                ApplicationArea = all;
            }
        }
    }
}
