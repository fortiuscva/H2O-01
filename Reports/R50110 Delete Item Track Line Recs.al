report 50110 "Delete Item Track Line Recs"
{
    ApplicationArea = All;
    Caption = 'Delete Item Track Line Recs';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;


    dataset
    {
        dataitem(TrackingSpec; "Tracking Specification")
        {
            DataItemTableView = SORTING("Entry No.");
            RequestFilterFields = "Source ID";


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
