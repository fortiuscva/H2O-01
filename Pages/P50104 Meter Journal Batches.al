page 50104 "Meter Journal Batches"
{
    ApplicationArea = All;
    Caption = 'Meter Journal Batches';
    PageType = List;
    SourceTable = "Meter Journal Batch";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("No. of Journal Lines"; rec."No. of Journal Lines")
                {
                    ToolTip = 'Indicates the No. of Unposted Journal Lines.';
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                    ApplicationArea = All;
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ToolTip = 'Specifies the value of the Posting No. Series field.';
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }


    actions
    {
        area(processing)
        {
            action("Edit Journal")
            {
                ApplicationArea = Jobs;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                ShortCutKey = 'Return';
                ToolTip = 'Open a journal based on the journal batch.';

                trigger OnAction()
                begin
                    MtrJnlMgt.TemplateSelectionFromBatch(Rec);
                end;
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        //ReportPrint.PrintResJnlBatch(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = Jobs;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    RunObject = Codeunit "Meter Jnl.-B.Post";
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                }
                action("Post and &Print")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    RunObject = Codeunit "Meter Jnl.-B.Post+Print";
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                }
            }
        }
    }

    var
        MtrJnlMgt: Codeunit "Meter Jnl Management";
        ReportPrint: Codeunit "Test Report-Print";



    trigger OnInit()
    begin
        rec.SetRange("Journal Template Name");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec.SetupNewBatch();
    end;

    trigger OnOpenPage()
    begin
        MtrJnlMgt.OpenJnlBatch(Rec);
    end;


    local procedure DataCaption(): Text[250]
    var
        MtrJnlTemplate: Record "Meter Journal Template";
    begin
        if not CurrPage.LookupMode then
            if rec.GetFilter("Journal Template Name") <> '' then
                if rec.GetRangeMin("Journal Template Name") = rec.GetRangeMax("Journal Template Name") then
                    if MtrJnlTemplate.Get(rec.GetRangeMin("Journal Template Name")) then
                        exit(MtrJnlTemplate.Name + ' ' + MtrJnlTemplate.Description);
    end;

}