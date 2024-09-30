pageextension 50107 "Pstd Sales Invoice Subform Ext" extends "Posted Sales Invoice Subform"
{
    layout
    {
        modify(Type)
        {
            ApplicationArea = All;
        }
        addbefore("Location Code")
        {
            field("Work Type Code"; rec."Work Type Code")
            {
                caption = 'Work Type Code';
                ToolTip = 'Specifies the Resource work type.';
                ApplicationArea = All;
            }
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
            field("Drop Shipment 2"; rec."Drop Shipment 2")
            {
                caption = 'Drop Shipment';
                ToolTip = 'Specifies whether or not the line is a drop shipment.';
                ApplicationArea = All;
            }
            field("Purchase Order No. 2"; rec."Purchase Order No. 2")
            {
                caption = 'Drop Shipment PO No.';
                ToolTip = 'Specifies the Drop Shipment Purchase Order No.';
                ApplicationArea = All;
                Editable = false;
            }
            field("Purch. Order Line No. 2"; rec."Purch. Order Line No. 2")
            {
                caption = 'Drop Shipment PO Line No.';
                ToolTip = 'Specifies the Drop Shipment Purchase Order Line No.';
                ApplicationArea = All;
                Editable = false;
                BlankZero = true;
            }

        }
        addafter("Amount Including VAT")
        {
            field("Rental Start Date"; rec."Rental Start Date")
            {
                caption = 'Rental Start Date';
                Tooltip = 'Specifies the start date of a rental resource period.';
                ApplicationArea = all;
            }
            field("Rental End Date"; rec."Rental End Date")
            {
                caption = 'Rental End Date';
                Tooltip = 'Specifies the end date of a rental resource period.';
                ApplicationArea = all;
            }
            field("Rental Days"; rec."Rental Days")
            {
                caption = 'Rental Days';
                Tooltip = 'Specifies the number of days the resource will be on rent.';
                ApplicationArea = all;
            }
            field("On Rent"; rec."On Rent")
            {
                caption = 'On Rent';
                Tooltip = 'Specifies if the rental resource is currently on rent.';
                ApplicationArea = all;
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
                BlankZero = true;
                ApplicationArea = all;
            }
            field("Original Completed Date"; rec."Original Completed Date")
            {
                caption = 'Original Completed Date';
                Tooltip = 'Specifies the original Work Order Completed Date';
                ApplicationArea = all;
            }
            field("Material Amount"; rec."Material Amount")
            {
                caption = 'Material Amount';
                Tooltip = 'Specifies the Amount of a Material line.';
                ApplicationArea = all;
                Editable = false;
                BlankZero = true;
                //Visible = Batch;
            }
            field("Labor Amount"; rec."Labor Amount")
            {
                caption = 'Labor Amount';
                Tooltip = 'Specifies the Amount of a Labor line.';
                ApplicationArea = all;
                Editable = false;
                BlankZero = true;
                //Visible = Batch;
            }
            field("Equipment Amount"; rec."Equipment Amount")
            {
                caption = 'Equipment Amount';
                Tooltip = 'Specifies the Amount of an Equipment line.';
                ApplicationArea = all;
                Editable = false;
                BlankZero = true;
                //Visible = Batch;
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
