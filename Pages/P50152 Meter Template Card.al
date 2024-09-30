page 50152 "Meter Template Card"
{
    ApplicationArea = All;
    Caption = 'Meter Template Card';
    PageType = Card;
    SourceTable = "Meter Template";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = all;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field.';
                    ApplicationArea = all;
                }
                field("No. Series"; rec."No. Series")
                {
                    ToolTip = 'Specifies the number series that will be used to assign numbers to Meters.';
                    ApplicationArea = all;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.';
                    ApplicationArea = all;
                }
                field("Meter Blocked Reason"; Rec."Meter Blocked Reason")
                {
                    ToolTip = 'Specifies the value of the Meter Blocked Reason field.';
                    ApplicationArea = all;
                }
                field("Customer Owned"; Rec."Customer Owned")
                {
                    ToolTip = 'Specifies the value of the Customer Owned field.';
                    ApplicationArea = all;
                }
            }
            group(Meter)
            {
                Caption = 'Meter';

                field("Meter Group Code"; Rec."Meter Group Code")
                {
                    ToolTip = 'Specifies the value of the Meter Group Code field.';
                    ApplicationArea = all;
                }
                field("Meter Type"; Rec."Meter Type")
                {
                    ToolTip = 'Specifies the value of the Meter Type field.';
                    ApplicationArea = all;
                }
                field("Meter Manufacturer Code"; Rec."Meter Manufacturer Code")
                {
                    ToolTip = 'Specifies the value of the Meter Manufacturer Code field.';
                    ApplicationArea = all;
                }
                field("Inspection Interval Gallons"; Rec."Inspection Interval Gallons")
                {
                    ToolTip = 'Specifies the value of the Inspection Interval Gallons field.';
                    ApplicationArea = all;
                }
                field("Meter Register Resolution"; Rec."Meter Register Resolution")
                {
                    ToolTip = 'Specifies the value of the Meter Register Resolution field.';
                    ApplicationArea = all;
                }
                field("No. of Dials"; Rec."No. of Dials")
                {
                    ToolTip = 'Specifies the value of the No. of Dials field.';
                    ApplicationArea = all;
                }
                field("Service Address Class Code"; Rec."Service Address Class Code")
                {
                    ToolTip = 'Specifies the value of the Service Address Class Code field.';
                    ApplicationArea = all;
                }
                field("Service Type"; Rec."Service Type")
                {
                    ToolTip = 'Specifies the value of the Service Type field.';
                    ApplicationArea = all;
                }
                field(Size; Rec.Size)
                {
                    ToolTip = 'Specifies the value of the Size field.';
                    ApplicationArea = all;
                }
                field("Utility Type"; Rec."Utility Type")
                {
                    ToolTip = 'Specifies the value of the Utility Type field.';
                    ApplicationArea = all;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';

                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                    ApplicationArea = all;
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ToolTip = 'Specifies the value of the Tax Group Code field.';
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = all;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = all;
                }
            }
        }
    }


    actions
    {
        area(Navigation)
        {
            action(Dimensions)
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = const(1382),
                              "No." = field(Code);
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
            }
            action(CopyTemplate)
            {
                ApplicationArea = All;
                Caption = 'Copy Template';
                Image = Copy;
                ToolTip = 'Copies all information to the current template from the selected one.';

                trigger OnAction()
                var
                    MeterTempl: Record "Meter Template";
                    MeterTemplList: Page "Meter Template List";
                begin
                    rec.TestField(Code);
                    MeterTempl.SetFilter(Code, '<>%1', rec.Code);
                    MeterTemplList.LookupMode(true);
                    MeterTemplList.SetTableView(MeterTempl);
                    if MeterTemplList.RunModal() = Action::LookupOK then begin
                        MeterTemplList.GetRecord(MeterTempl);
                        rec.CopyFromTemplate(MeterTempl);
                    end;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(CopyTemplate_Promoted; CopyTemplate)
                {
                }
                actionref(Dimensions_Promoted; Dimensions)
                {
                }
            }
        }
    }


    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ResourceSetup: Record "Resources Setup";
    begin
        if rec.Code <> '' then
            exit;

        if not ResourceSetup.Get() then
            exit;
    end;


    trigger OnInit()
    begin
        InitControls();
    end;


    trigger OnOpenPage()
    begin
    end;


    local procedure InitControls()
    begin
    end;
}
