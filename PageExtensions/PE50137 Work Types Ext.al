pageextension 50137 "Work Types Ext" extends "Work Types"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field(Contract; rec.Contract)
            {
                ApplicationArea = All;
                caption = 'Contract';
                ToolTip = 'Specifies if this code is for Contract pricing.';
            }
            field(Overtime; rec.Overtime)
            {
                ApplicationArea = All;
                caption = 'Overtime';
                ToolTip = 'Specifies if this code is for Overtime pricing.';
            }
        }
    }
}
