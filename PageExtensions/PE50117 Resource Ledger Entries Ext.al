pageextension 50117 "Resource Ledger Entries Ext" extends "Resource Ledger Entries"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field(Rental; rec.Rental)
            {
                caption = 'Rental';
                ToolTip = 'Specifies whether the Resource is a rental.';
                ApplicationArea = All;
            }
            field("On Rent"; rec."On Rent")
            {
                caption = 'On Rent';
                ToolTip = 'Specifies whether the Resource is currently on rent.';
                ApplicationArea = All;
            }
            field("Rental Start Date"; rec."Rental Start Date")
            {
                caption = 'Rental Start Date';
                ToolTip = 'Specifies the Rental Start Date if the Resource is currently on rent.';
                ApplicationArea = All;
            }
            field("Rental End Date"; rec."Rental End Date")
            {
                caption = 'Rental End Date';
                ToolTip = 'Specifies the Rental Start Date if the Resource is currently on rent.';
                ApplicationArea = All;
            }
            field("Rental Days"; rec."Rental Days")
            {
                caption = 'Rental Days';
                ToolTip = 'Specifies the number of days the resource is currently on rent.';
                ApplicationArea = All;
            }
        }
    }
}