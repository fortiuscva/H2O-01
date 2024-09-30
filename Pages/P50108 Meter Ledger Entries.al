page 50108 "Meter Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Meter Ledger Entries';
    PageType = List;
    SourceTable = "Meter Ledger Entry";
    Editable = false;
    DataCaptionFields = "Meter No.";
    SourceTableView = SORTING("Meter No.", "Posting Date")
                      ORDER(Descending);
    UsageCategory = History;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the value of the External Document No. field.';
                    ApplicationArea = All;
                }
                field("Meter No."; Rec."Meter No.")
                {
                    ToolTip = 'Specifies the value of the Meter No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field.';
                    ApplicationArea = All;
                }
                field("Serial No."; rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the Serial No. field.';
                    ApplicationArea = All;
                }
                field("Meter Activity Code"; Rec."Meter Activity Code")
                {
                    ToolTip = 'Specifies the value of the Activity Type field.';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    ApplicationArea = All;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ToolTip = 'Specifies the value of the Ship-to Code field.';
                    ApplicationArea = All;
                }
                field("Previous Meter Reading"; Rec."Previous Meter Reading")
                {
                    ToolTip = 'Specifies the value of the Previous Meter Reading field.';
                    ApplicationArea = All;
                }
                field("Previous Meter Reading Date"; Rec."Previous Meter Reading Date")
                {
                    ToolTip = 'Specifies the value of the Previous Meter Reading Date field.';
                    ApplicationArea = All;
                }
                field("Current Meter Reading"; Rec."Current Meter Reading")
                {
                    ToolTip = 'Specifies the value of the Current Meter Reading field.';
                    ApplicationArea = All;
                }
                field("Current Meter Reading Date"; Rec."Current Meter Reading Date")
                {
                    ToolTip = 'Specifies the value of the Current Meter Reading Date field.';
                    ApplicationArea = All;
                }
                field("Water Usage"; Rec."Water Usage")
                {
                    ToolTip = 'Specifies the value of the Water Usage field.';
                    ApplicationArea = All;
                }
                field("Re-Read Required"; rec."Re-read Required")
                {
                    ToolTip = 'If this field is checked, the current reading exceeds the threshold percentage, requiring a meter re-read.';
                    ApplicationArea = All;
                }
                field("Meter Reading Threshold"; rec."Meter Reading Threshold")
                {
                    ToolTip = 'If Re-Read Required is checked, this value should be greater than the Water Usage value.';
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field(Corrected; Rec.Corrected)
                {
                    ToolTip = 'If checked, this meter ledger entry has been corected.';
                    ApplicationArea = All;
                }
                field("Corrected Entry No."; Rec."Corrected Entry No.")
                {
                    ToolTip = 'Specifies the original entry which was corrected.';
                    ApplicationArea = All;
                }
                field("Corrected Date"; Rec."Corrected Date")
                {
                    ToolTip = 'Specifies the Correction Date.';
                    ApplicationArea = All;
                }
                field("Must Send To Opus"; Rec."Must Send To Opus")
                {
                    ToolTip = 'Specifies if the transaction must be sent to Opus.';
                    ApplicationArea = All;
                }
                field("Sent To Opus"; Rec."Sent To Opus")
                {
                    ToolTip = 'Specifies if the transaction was sent to Opus.';
                    ApplicationArea = All;
                }
                field("Sent To Opus Date"; Rec."Sent To Opus Date")
                {
                    ToolTip = 'Specifies the date the transaction was sent to Opus.';
                    ApplicationArea = All;
                }
                field("Sent To Opus Time"; Rec."Sent To Opus Time")
                {
                    ToolTip = 'Specifies the time the transaction was sent to Opus.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        rec.ShowDimensions();
                    end;
                }
                action(SetDimensionFilter)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Set Dimension Filter';
                    Ellipsis = true;
                    Image = "Filter";
                    ToolTip = 'Limit the entries according to the dimension filters that you specify. NOTE: If you use a high number of dimension combinations, this function may not work and can result in a message that the SQL server only supports a maximum of 2100 parameters.';

                    trigger OnAction()
                    begin
                        rec.SetFilter("Dimension Set ID", DimensionSetIDFilter.LookupFilter());
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Jobs;
                Caption = 'Find entries...';
                Image = Navigate;
                ShortCutKey = 'Ctrl+Alt+Q';
                ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';

                trigger OnAction()
                begin
                    Navigate.SetDoc(rec."Posting Date", rec."Document No.");
                    Navigate.Run();
                end;
            }
            action("Send Mtr Ledg Entry To Opus")
            {
                caption = 'Send Meter Ledger Entries to Opus';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Xmlport.Run(50106, false, false);
                end;
            }

        }
    }


    trigger OnOpenPage()
    begin
        SetDimVisibility();

        if (rec.GetFilters() <> '') and not rec.Find() then
            if rec.FindFirst() then;
    end;


    var
        Navigate: Page Navigate;
        DimensionSetIDFilter: Page "Dimension Set ID Filter";

    protected var
        Dim1Visible: Boolean;
        Dim2Visible: Boolean;
        Dim3Visible: Boolean;
        Dim4Visible: Boolean;
        Dim5Visible: Boolean;
        Dim6Visible: Boolean;
        Dim7Visible: Boolean;
        Dim8Visible: Boolean;



    local procedure SetDimVisibility()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(Dim1Visible, Dim2Visible, Dim3Visible, Dim4Visible, Dim5Visible, Dim6Visible, Dim7Visible, Dim8Visible);
    end;

}
