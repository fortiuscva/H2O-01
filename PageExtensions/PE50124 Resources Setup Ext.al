pageextension 50124 "Resources Setup Ext" extends "Resources Setup"
{
    layout
    {
        addfirst(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Use Resource Customer Prices"; Rec."Use Resource Customer Prices")
                {
                    ApplicationArea = All;
                    ToolTip = 'If checked, the system will use the new Resource/Customer price calculation.';
                }
            }
        }
    }
}