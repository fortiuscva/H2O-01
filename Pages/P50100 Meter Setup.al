page 50100 "Meter Setup"
{
    ApplicationArea = All;
    Caption = 'Meter Setup';
    PageType = Card;
    SourceTable = "Meter Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Meter Nos."; Rec."Meter Nos.")
                {
                    ToolTip = 'Specifies the value of the Meter Nos. field.';
                    ApplicationArea = All;
                }
            }
            group(Defaults)
            {
                Caption = 'Defaults';

                field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Default Gen. Prod. Posting Group field.';
                    ApplicationArea = All;
                }
                field("Req. Ship-to Code Sale"; rec."Req. Ship-to Code Sale")
                {
                    caption = 'Req. Ship-to Code on Sales Orders';
                    ToolTip = 'Specifies if the Ship-to Code is required on Sales Orders.';
                    ApplicationArea = All;
                }
                field("Req. Ship-to Code Inv"; rec."Req. Ship-to Code Inv")
                {
                    caption = 'Req. Ship-to Code on Work Orders';
                    ToolTip = 'Specifies if the Ship-to Code is required on Work Orders.';
                    ApplicationArea = All;
                }
                field("Req. Ship-to Code Read"; rec."Req. Ship-to Code Read")
                {
                    caption = 'Req. Ship-to Code on Meter Journals';
                    ToolTip = 'Specifies if the Ship-to Code is required on Meter Reads.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Req"; rec."Global Dimension 1 Req")
                {
                    caption = 'Global Dimension 1 Req.';
                    ToolTip = 'Specifies which sales table, if any, Global Dimension 1 is required.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Req"; rec."Global Dimension 2 Req")
                {
                    caption = 'Global Dimension 2 Req.';
                    ToolTip = 'Specifies which sales table, if any, Global Dimension 2 is required.';
                    ApplicationArea = All;
                }
                field("Default Warranty Period"; rec."Default Warranty Period")
                {
                    caption = 'Warranty Period';
                    ToolTip = 'Specifies the default time period of meter warranty.';
                    ApplicationArea = All;
                }
                field("Def. Jnl Template"; rec."Def. Jnl Templ. for Mtr Read")
                {
                    caption = 'Def. Jnl Template for Meter Reads';
                    ToolTip = 'Specifies the default meter journal template for remote meter reads.';
                    ApplicationArea = All;
                }
                field("Def. Jnl Batch"; rec."Def. Jnl Batch for Mtr Read")
                {
                    caption = 'Def. Jnl Batch for Meter Reads';
                    ToolTip = 'Specifies the default meter journal batch for remote meter reads.';
                    ApplicationArea = All;
                }
                field("Meter Reading Threshold"; rec."Meter Reading Threshold")
                {
                    caption = 'Meter Reading Threshold %';
                    ToolTip = 'If this is checked and meter readings from one month to the next exceeds this percentage threshold, a re-read is triggered.';
                    ApplicationArea = All;
                }
                field("Meter Reading Day"; rec."Meter Reading Day")
                {
                    caption = 'Meter Reading Day';
                    ToolTip = 'Default day of month that meters are read.';
                    ApplicationArea = All;
                }
                field("Batch Invoice Day"; rec."Batch Invoice Day")
                {
                    caption = 'Batch Invoice Day';
                    ToolTip = 'Default day of month that batch invoices are created.';
                    ApplicationArea = All;
                }
                field("Opus Transmission Day"; rec."Opus Transmission Day")
                {
                    caption = 'Opus Transmission Day';
                    ToolTip = 'Default day of month that results are transmitted to Opus.';
                    ApplicationArea = All;
                }

            }
            group(Uploads)
            {
                caption = 'Meter Uploads';

                field("Verify Customer No."; rec."Verify Customer No.")
                {
                    caption = 'Verify Customer Nos.';
                    ToolTip = 'If this is checked, Customer Nos. will be verified during Config. Pack. uploads.';
                    ApplicationArea = All;
                }
                field("Verify Ship-To Code"; rec."Verify Ship-to Code")
                {
                    caption = 'Verify Ship-to Codes';
                    ToolTip = 'If this is checked, Ship-to Codes will be verified during Config. Pack. uploads.';
                    ApplicationArea = All;
                }

            }
        }
    }
}
