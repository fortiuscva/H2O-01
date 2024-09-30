tableextension 50119 "Resources Setup Ext" extends "Resources Setup"
{
    fields
    {
        field(50100; "Skip Prompt to Create Res."; boolean)
        {
            Caption = 'Skip Prompt to Create Res.';
            DataClassification = ToBeClassified;
        }
        field(50101; "Use Resource Customer Prices"; boolean)
        {
            Caption = 'Use Resource/Customer Prices';
            DataClassification = ToBeClassified;
        }
    }
}
