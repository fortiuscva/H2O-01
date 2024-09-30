page 50105 "Meter Journal"
{
    ApplicationArea = All;
    Caption = 'Meter Journal';
    PageType = Worksheet;
    SourceTable = "Meter Journal Line";
    AutoSplitKey = true;
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    SaveValues = true;
    UsageCategory = Tasks;


    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Jobs;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    MtrJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    SetControlAppearanceFromBatch();
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    MtrJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali();
                end;
            }
            repeater(General)
            {
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name';
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    Caption = 'Line No.';
                    ToolTip = 'Specifies the value of the Line No. field.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    caption = 'Posting Date';
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Caption = 'Document Date';
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    caption = 'Extenal Document No.';
                    ToolTip = 'Specifies the value of the External Document No. field.';
                    ApplicationArea = All;
                    visible = false;
                }
                field("Meter No."; Rec."Meter No.")
                {
                    caption = 'Meter No.';
                    ToolTip = 'Specifies the value of the Meter No. field.';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    ApplicationArea = All;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    caption = 'Property No.';
                    ToolTip = 'Specifies the value of the Ship-to Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    caption = 'Description 2';
                    ToolTip = 'Specifies the value of the Description 2 field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Serial No."; rec."Serial No.")
                {
                    caption = 'Serial No.';
                    ToolTip = 'Specifies the value of the Serial No. field.';
                    ApplicationArea = All;
                }
                field("Previous Meter Reading"; Rec."Previous Meter Reading")
                {
                    caption = 'Previous Meter Reading';
                    ToolTip = 'Specifies the value of the Previous Meter Reading field.';
                    ApplicationArea = All;
                }
                field("Previous Meter Reading Date"; Rec."Previous Meter Reading Date")
                {
                    caption = 'Previous Meter Reading Date';
                    ToolTip = 'Specifies the value of the Previous Meter Reading Date field.';
                    ApplicationArea = All;
                }
                field("Current Meter Reading"; Rec."Current Meter Reading")
                {
                    caption = 'Current Meter Reading';
                    ToolTip = 'Specifies the value of the Current Meter Reading field.';
                    ApplicationArea = All;
                }
                field("Re-Read Required"; rec."Re-read Required")
                {
                    caption = 'Re-Read Required';
                    ToolTip = 'If this field is checked, the current reading exceeds the threshold percentage, requiring a meter re-read.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Current Meter Reading Date"; Rec."Current Meter Reading Date")
                {
                    caption = 'Current Meter Reading Date';
                    ToolTip = 'Specifies the value of the Current Meter Reading Date field.';
                    ApplicationArea = All;
                }
                field("Water Usage"; Rec."Water Usage")
                {
                    caption = 'Water Usage';
                    ToolTip = 'Specifies the value of the Water Usage field.';
                    ApplicationArea = All;
                }
                field("Meter Reading Threshold"; rec."Meter Reading Threshold")
                {
                    caption = 'Meter Reading Threshold';
                    ToolTip = 'If Re-Read Required is checked, this value should be greater than the Water Usage value.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Shorcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("Meter Trouble Code"; Rec."Meter Trouble Code")
                {
                    caption = 'Trouble Code';
                    ToolTip = 'Specifies the value of the Trouble Code.';
                    ApplicationArea = All;
                }
                field("Meter Skip Code"; Rec."Meter Skip Code")
                {
                    caption = 'Skip Code';
                    ToolTip = 'Specifies the value of the Skip Code.';
                    ApplicationArea = All;
                }
                field(Correction; Rec.Correction)
                {
                    caption = 'Correction';
                    ToolTip = 'If checked, the Applies-to Doc. No. must contain a value.';
                    ApplicationArea = All;
                }
                field("Applies-to Entry No."; Rec."Applies-to Entry No.")
                {
                    caption = 'Applies-to Entry No.';
                    ToolTip = 'Specifies the Document No. to be corrected.';
                    ApplicationArea = All;
                    BlankZero = true;
                }
            }
        }
        area(factboxes)
        {
            //part(MtrJnlLinePicture; rec.Picture)
            //{
            //    ApplicationArea = All;
            //    Caption = 'Picture';
            //    SubPageLink = "Meter No." = FIELD("Meter No.");
            //}

        }
    }


    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
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
                        CurrPage.SaveRecord();
                    end;
                }
            }
            group("&Meter")
            {
                Caption = '&Meter';
                Image = Resource;
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Meter Card";
                    RunPageLink = "No." = FIELD("Meter No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record on the document or journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = ResourceLedger;
                    RunObject = Page "Meter Ledger Entries";
                    RunPageLink = "Meter No." = FIELD("Meter No.");
                    RunPageView = SORTING("Meter No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = All;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        //ReportPrint.PrintResJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Meter Jnl.-Post", Rec);
                        CurrentJnlBatchName := rec.GetRangeMax(rec."Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = All;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Res. Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := rec.GetRangeMax(rec."Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
            group("Preview Post")
            {

            }
            //group("F&unctions")
            //{
            //    Caption = 'F&unctions';
            //    Image = "Action";
            //    action(SuggestLinesFromTimeSheets)
            //    {
            //        ApplicationArea = Jobs;
            //        Caption = 'Suggest Lines from Time Sheets';
            //        Ellipsis = true;
            //        Image = SuggestLines;
            //        ToolTip = 'Fill the journal with lines that exist in the time sheets.';

            //        trigger OnAction()
            //        var
            //            SuggestResJnlLines: Report "Suggest Res. Jnl. Lines";
            //        begin
            //            SuggestResJnlLines.SetResJnlLine(Rec);
            //            SuggestResJnlLines.RunModal();
            //        end;
            //    }
            //}
            group("Page")
            {
                Caption = 'Page';
                action(EditInExcel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Edit in Excel';
                    Image = Excel;
                    ToolTip = 'Send the data in the journal to an Excel file for analysis or editing.';
                    Visible = IsSaaSExcelAddinEnabled;
                    AccessByPermission = System "Allow Action Export To Excel" = X;

                    trigger OnAction()
                    var
                        ODataUtility: Codeunit ODataUtility;
                    begin
                        ODataUtility.EditJournalWorksheetInExcel(CurrPage.Caption, CurrPage.ObjectId(false), rec."Journal Batch Name", rec."Journal Template Name");
                    end;
                }
                group(Errors)
                {
                    Caption = 'Issues';
                    Image = ErrorLog;
                    Visible = BackgroundErrorCheck;
                    action(ShowLinesWithErrors)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Lines with Issues';
                        Image = Error;
                        Visible = BackgroundErrorCheck;
                        Enabled = not ShowAllLinesEnabled;
                        ToolTip = 'View a list of journal lines that have issues before you post the journal.';

                        trigger OnAction()
                        begin
                            rec.SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
                        end;
                    }
                    action(ShowAllLines)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show All Lines';
                        Image = ExpandAll;
                        Visible = BackgroundErrorCheck;
                        Enabled = ShowAllLinesEnabled;
                        ToolTip = 'View all journal lines, including lines with and without issues.';

                        trigger OnAction()
                        begin
                            rec.SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
                        end;
                    }
                }
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        MtrJnlManagement.GetMtr(rec."Meter No.", rec.Description);
    end;


    trigger OnAfterGetRecord()
    begin
        rec.ShowShortcutDimCode(ShortcutDimCode);
    end;


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec.SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
    end;


    trigger OnOpenPage()
    var
        ServerSetting: Codeunit "Server Setting";
        JnlSelected: Boolean;
    begin
        IsSaaSExcelAddinEnabled := ServerSetting.GetIsSaasExcelAddinEnabled();
        if ClientTypeManagement.GetCurrentClientType() = CLIENTTYPE::ODataV4 then
            exit;

        SetDimensionsVisibility();

        //OnOpenPageOnBeforeOpenJnl(Rec, CurrentJnlBatchName);

        if rec.IsOpenedFromBatch() then begin
            CurrentJnlBatchName := rec."Journal Batch Name";
            MtrJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            SetControlAppearanceFromBatch();
            exit;
        end;
        MtrJnlManagement.TemplateSelection(PAGE::"Meter Journal", Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        MtrJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
        SetControlAppearanceFromBatch();
    end;


    var
        CurrentJnlBatchName: Code[10];
        MtrJnlManagement: codeunit "Meter Jnl Management";
        MtrJournalErrorsMgt: Codeunit "Meter Journal Errors Mgt.";
        ClientTypeManagement: Codeunit "Client Type Management";
        BackgroundErrorCheck: Boolean;
        ShowAllLinesEnabled: Boolean;
        IsSaaSExcelAddinEnabled: Boolean;

    protected var
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;


    local procedure SetControlAppearanceFromBatch()
    var
        MtrJournalBatch: Record "Meter Journal Batch";
        BackgroundErrorHandlingMgt: Codeunit "Background Error Handling Mgt.";
    begin
        //if not MtrJournalBatch.Get("Journal Template Name", CurrentJnlBatchName) then
        //    exit;

        BackgroundErrorCheck := BackgroundErrorHandlingMgt.BackgroundValidationFeatureEnabled();
        ShowAllLinesEnabled := true;
        //SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
        MtrJournalErrorsMgt.SetFullBatchCheck(true);
    end;


    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        MtrJnlManagement.SetName(CurrentJnlBatchName, Rec);
        SetControlAppearanceFromBatch();
        CurrPage.Update(false);
    end;


    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);
    end;

}
