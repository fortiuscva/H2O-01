pageextension 50132 "Sales Ret Order Subform Ext" extends "Sales Return Order Subform"
{
    layout
    {
        modify(Type)
        {
            ApplicationArea = All;
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
                Tooltip = 'A lookup to the Meter Serial No.';
                ApplicationArea = all;
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
            field("On Rent"; rec."On Rent")
            {
                caption = 'On Rent';
                Tooltip = 'Specifies if the rental resource is currently on rent.';
                ApplicationArea = all;
            }
            field("Original Documet No."; rec."Original Document No.")
            {
                caption = 'Original Documet No.';
                Tooltip = 'Specifies the original Work Order No.';
                ApplicationArea = all;
            }
            field("Original Line No."; rec."Original Line No.")
            {
                caption = 'Original Documet No.';
                Tooltip = 'Specifies the original Work Order Line No.';
                ApplicationArea = all;
            }
        }
    }

}
