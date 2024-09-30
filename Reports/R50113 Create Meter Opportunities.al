report 50113 "Create Meter Opportunities"
{
    ApplicationArea = All;
    Caption = 'Create Meter Reading Opportunities';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {
        dataitem(MeterReadOpp; "Meter Read Opportunity")
        {
            DataItemTableView = SORTING("journal template name", "journal batch name", "Line No.");

            trigger OnAfterGetRecord()
            begin
                clear(SalesLine);

                if TroubleCode.get("Trouble Code") then
                    CodeText := TroubleCode.Description;
                If SkipCode.get("Skip Code") then
                    CodeText := SkipCode.Description;

                SalesHeader.init;
                SalesHeader."Document Type" := salesheader."Document Type"::Invoice;
                SalesHeader.validate("Sell-to Customer No.", "Customer No.");
                SalesHeader.validate("Ship-to Code", "Ship-to Code");
                SalesHeader.validate("Posting Date", today);
                SalesHeader.validate("Document Date", today);
                SalesHeader.validate("Include In Batch Invoicing", true);
                SalesHeader.Purpose := CodeText;
                SalesHeader."Generated from Meter Read Opp." := true;
                SalesHeader.insert(true);

                SalesLine.init;
                SalesLine.validate("Document Type", SalesHeader."Document Type");
                SalesLine.validate("Document No.", SalesHeader."No.");
                SalesLine."Line No." += 10000;
                SalesLine.validate(Type, SalesLine.Type::Meter);
                SalesLine.validate("No.", "Meter No.");

                MtrActivity.reset;
                MtrActivity.setrange("Meter Reading Opportunity", true);
                If MtrActivity.findfirst then
                    SalesLine.validate("Meter Activity Code", MtrActivity.code);

                SalesLine.insert(false);

                If DeleteRecs then
                    MeterReadOpp.delete
                else begin
                    MeterReadOpp."Work Order Created" := true;
                    MeterReadOpp.modify;
                end;
            end;
        }
    }


    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    caption = 'Option';

                    field(DeleteRecs; DeleteRecs)
                    {
                        caption = 'Delete Opportunity Records';
                        ApplicationArea = all;
                        ToolTip = 'If checked, opporunity records will be deleted after creating work orders.';
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }



    var
        SalesHeader: record "Sales Header";
        SalesLine: record "Sales Line";
        TroubleCode: record "Trouble Code";
        SkipCode: record "Skip Code";
        MtrActivity: record "Meter Activity";
        CodeText: text;
        DeleteRecs: Boolean;
}
