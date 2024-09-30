pageextension 50102 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter(Blocked)
        {
            field(Meter; rec.Meter)
            {
                caption = 'Meter';
                ToolTip = 'Specifies whether the Item is a Meter.';
                ApplicationArea = All;
            }
        }
        addafter("Over-Receipt Code")
        {
            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ToolTip = 'Specifies the value of the Global Dimension 1 Code.';
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
            {
                ToolTip = 'Specifies the value of the Global Dimension 2 Code.';
                ApplicationArea = All;
            }
        }
        addafter("Unit Cost")
        {
            field("Highest Unit Cost"; rec."Highest Unit Cost")
            {
                caption = 'Highest Unit Cost';
                ToolTip = 'Specifies the highest unit cost paid for this item.';
                ApplicationArea = All;
            }
        }
    }
}
