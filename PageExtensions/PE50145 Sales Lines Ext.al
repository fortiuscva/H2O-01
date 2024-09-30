pageextension 50145 "Sales Lines Ext" extends "Sales Lines"
{
    layout
    {
        addbefore("Shipment Date")
        {
            field("Material Amount"; rec."Material Amount")
            {
                caption = 'Material Amount';
                ToolTip = 'Specifies the material amount of the sales line.';
                ApplicationArea = All;
            }
            field("Labor Amount"; rec."Labor Amount")
            {
                caption = 'Labor Amount';
                ToolTip = 'Specifies the labor amount of the sales line.';
                ApplicationArea = All;
            }
            field("Equipment Amount"; rec."Equipment Amount")
            {
                caption = 'Equipment Amount';
                ToolTip = 'Specifies the equipment amount of the sales line.';
                ApplicationArea = All;
            }
        }
    }
}
