pageextension 50162 "Sales Quotes Ext" extends "Sales Quotes"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(Purpose; Rec.Purpose)
            {
                caption = 'Task';
                ToolTip = 'Identifies the task of this Work Order Template';
                ApplicationArea = All;
            }
        }
    }
}
