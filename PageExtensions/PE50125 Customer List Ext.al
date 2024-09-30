pageextension 50125 "Customer List Ext" extends "Customer List"
{
    layout
    {
        addafter(Contact)
        {
            field("Must Send To Oput"; rec."Must Send To Opus")
            {
                Caption = 'Must Send To Opus';
                ApplicationArea = all;
            }
            field("Must Send To Mendix"; rec."Must Send To Mendix")
            {
                Caption = 'Must Send To Mendix';
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            group("Export Customers")
            {
                action("Send Customers To Opus")
                {
                    caption = 'Send Customers to Opus';
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        Xmlport.Run(50100, false, false);
                    end;
                }
                action("Send Customers To Mendix")
                {
                    caption = 'Send Customers to Mendix';
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        Xmlport.Run(50101, false, false);
                    end;
                }
            }
        }
    }
}
