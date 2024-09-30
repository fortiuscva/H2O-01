report 50109 "Delete Sales Line Recs"
{
    ApplicationArea = All;
    Caption = 'Delete Sales Line Recs';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;


    dataset
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Document No.";


            trigger OnAfterGetRecord()
            begin
                deleteall;
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
}
