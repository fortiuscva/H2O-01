table 50100 "Meter Setup"
{
    Caption = 'Meter Setup';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Setup";
    DrillDownPageId = "Meter Setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(2; "Meter Nos."; Code[20])
        {
            Caption = 'Meter Nos.';
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(10; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Default Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
            DataClassification = ToBeClassified;
        }
        field(15; "Req. Ship-to Code Sale"; Boolean)
        {
            Caption = 'Require Ship-to Code for Sales Orders';
            DataClassification = ToBeClassified;
        }
        field(16; "Req. Ship-to Code Inv"; boolean)
        {
            Caption = 'Require Ship-to Code for Work Orders';
            DataClassification = ToBeClassified;
        }
        field(17; "Req. Ship-to Code Read"; Boolean)
        {
            Caption = 'Require Ship-to Code for Meter Reads';
            DataClassification = ToBeClassified;
        }
        field(18; "Global Dimension 1 Req"; enum "Global Dimension Req.")
        {
            Caption = 'Global Dimension 1 Req';
            DataClassification = ToBeClassified;
        }
        field(19; "Global Dimension 2 Req"; enum "Global Dimension Req.")
        {
            Caption = 'Global Dimension 1 Req';
            DataClassification = ToBeClassified;
        }
        field(20; "Default Warranty Period"; DateFormula)
        {
            caption = 'Default Warranty Period';
            DataClassification = ToBeClassified;
        }
        field(25; "Def. Jnl Templ. for Mtr Read"; code[10])
        {
            caption = 'Def. Jnl Templ. for Mtr Read.';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Template";
        }
        field(30; "Def. Jnl Batch for Mtr Read"; code[10])
        {
            caption = 'Def. Jnl Batch for Mtr Read.';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Batch".Name WHERE("Journal Template Name" = FIELD("Def. Jnl Templ. for Mtr Read"));
        }
        field(35; "Meter Reading Threshold"; decimal)
        {
            Caption = 'Meter Reading Threshold %';
            DataClassification = ToBeClassified;
        }
        field(40; "Verify Customer No."; boolean)
        {
            Caption = 'Verify Customer No.';
            DataClassification = ToBeClassified;
        }
        field(45; "Verify Ship-to Code"; boolean)
        {
            Caption = 'Verify Ship-to Code';
            DataClassification = ToBeClassified;
        }
        field(50; "Meter Reading Day"; integer)
        {
            Caption = 'Meter Reading Day';
            DataClassification = ToBeClassified;
            MinValue = 1;
            MaxValue = 31;
        }
        field(55; "Batch Invoice Day"; integer)
        {
            Caption = 'Batch Invoice Day';
            DataClassification = ToBeClassified;
            MinValue = 1;
            MaxValue = 31;
        }
        field(60; "Opus Transmission Day"; integer)
        {
            Caption = 'Opus Transmission Day';
            DataClassification = ToBeClassified;
            MinValue = 1;
            MaxValue = 31;
        }


    }


    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
