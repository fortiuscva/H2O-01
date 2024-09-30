pageextension 50101 "Ship-To Address List Ext" extends "Ship-to Address List"
{
    caption = 'Service Addresses';

    layout
    {
        modify(Code)
        {
            Caption = 'Property No.';
        }
        modify("Location Code")
        {
            Visible = false;
        }


        addafter(City)
        {
            field(County; rec.County)
            {
                caption = 'State';
                ToolTip = 'Specifies the value of the State field.';
                ApplicationArea = All;
            }
            field("Location Stop"; Rec."Location Stop")
            {
                caption = 'Location Stop';
                ToolTip = 'Specifies the value of the Location Stop field.';
                ApplicationArea = All;
            }
            field("Must Send To Opus"; rec."Must Send To Opus")
            {
                caption = 'Must Send To Opus';
                ToolTip = 'Identifies if the Ship-to Address must be sent to Opus.';
                ApplicationArea = All;
            }
            field("Must Send to Mendix"; rec."Must Send To Mendix")
            {
                caption = 'Must Send To Mendix';
                ToolTip = 'Identifies if the Ship-to Address must be sent to Mendix';
                ApplicationArea = All;
            }
        }

        addafter(Code)
        {
            field("Opus Account No."; rec."Opus Account No.")
            {
                caption = 'Opus Account No.';
                ToolTip = 'Identifies the Opus Account No.';
                ApplicationArea = All;
            }
        }
    }



    actions
    {
        addafter("Online Map")
        {
            group("Export Ship-to Addresses")
            {
                action("Send Ship-tos To Opus")
                {
                    caption = 'Send Ship-tos to Opus';
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        Xmlport.Run(50102, false, false);
                    end;
                }
                action("Send Ship-tos To Mendix")
                {
                    caption = 'Send Ship-tos to Mendix';
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        Xmlport.Run(50103, false, false);
                    end;
                }
            }
        }
    }
}