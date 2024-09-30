report 50102 "Create H2O Calendar"
{
    ApplicationArea = All;
    Caption = 'Create H2O Calendar';
    UsageCategory = Tasks;
    ProcessingOnly = true;



    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Enter Calendar Start Date';
                        ToolTip = 'Prints all task lines whose Job Task Type is Total or End-Total.';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Enter Calendar End Date';
                        ToolTip = 'Prints all task lines marked as Labor.';
                    }
                    field(StartTime; StartTime)
                    {
                        ApplicationArea = All;
                        Caption = 'Enter Contract Start Time';
                        ;
                        ToolTip = 'Prints all task lines marked as Material.';
                    }
                    field(EndTime; Endtime)
                    {
                        ApplicationArea = All;
                        Caption = 'Enter Contract End Time';
                        ToolTip = 'Prints all task lines marked as Equipment.';
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
        StartDate: date;
        EndDate: date;
        StartTime: time;
        EndTime: time;
        DateTbl: record Date;
        H2OCalendar2: record "H2O Calendar";
        H2OCalendar1: record "H2O Calendar";


    trigger OnPreReport()
    begin
        H2OCalendar2.setrange(Date, StartDate, EndDate);
        H2OCalendar2.deleteall;

        DateTbl.reset;
        DateTbl.setrange("Period Type", DateTbl."Period Type"::Date);
        DateTbl.setrange("Period Start", StartDate, EndDate);
        IF DateTbl.findset then
            repeat
                H2OCalendar1.init;
                H2OCalendar1.Date := DateTbl."Period Start";

                If DateTbl."Period Name" = 'Sunday' then begin
                    H2OCalendar1."Day of Week" := H2OCalendar1."Day of Week"::Sunday;
                    H2OCalendar1."Nonworking Day" := true;
                    H2OCalendar1."Contract Start Time" := 0T;
                    H2OCalendar1."Contract End Time" := 0T;
                    H2OCalendar1.ContractST := 0DT;
                    H2OCalendar1.ContractET := 0DT;
                end;

                If DateTbl."Period Name" = 'Monday' then begin
                    H2OCalendar1."Day of Week" := H2OCalendar1."Day of Week"::Monday;
                    H2OCalendar1."Contract Start Time" := StartTime;
                    H2OCalendar1."Contract End Time" := EndTime;
                    H2OCalendar1.ContractST := CreateDateTime(H2OCalendar1.Date, StartTime);
                    H2OCalendar1.ContractET := CreateDateTime(H2OCalendar1.Date, EndTime);
                end;

                If DateTbl."Period Name" = 'Tuesday' then begin
                    H2OCalendar1."Day of Week" := H2OCalendar1."Day of Week"::Tuesday;
                    H2OCalendar1."Contract Start Time" := StartTime;
                    H2OCalendar1."Contract End Time" := EndTime;
                    H2OCalendar1.ContractST := CreateDateTime(H2OCalendar1.Date, StartTime);
                    H2OCalendar1.ContractET := CreateDateTime(H2OCalendar1.Date, EndTime);
                end;

                If DateTbl."Period Name" = 'Wednesday' then begin
                    H2OCalendar1."Day of Week" := H2OCalendar1."Day of Week"::Wednesday;
                    H2OCalendar1."Contract Start Time" := StartTime;
                    H2OCalendar1."Contract End Time" := EndTime;
                    H2OCalendar1.ContractST := CreateDateTime(H2OCalendar1.Date, StartTime);
                    H2OCalendar1.ContractET := CreateDateTime(H2OCalendar1.Date, EndTime);
                end;

                If DateTbl."Period Name" = 'Thursday' then begin
                    H2OCalendar1."Day of Week" := H2OCalendar1."Day of Week"::Thursday;
                    H2OCalendar1."Contract Start Time" := StartTime;
                    H2OCalendar1."Contract End Time" := EndTime;
                    H2OCalendar1.ContractST := CreateDateTime(H2OCalendar1.Date, StartTime);
                    H2OCalendar1.ContractET := CreateDateTime(H2OCalendar1.Date, EndTime);
                end;

                If DateTbl."Period Name" = 'Friday' then begin
                    H2OCalendar1."Day of Week" := H2OCalendar1."Day of Week"::Friday;
                    H2OCalendar1."Contract Start Time" := StartTime;
                    H2OCalendar1."Contract End Time" := EndTime;
                    H2OCalendar1.ContractST := CreateDateTime(H2OCalendar1.Date, StartTime);
                    H2OCalendar1.ContractET := CreateDateTime(H2OCalendar1.Date, EndTime);
                end;

                If DateTbl."Period Name" = 'Saturday' then begin
                    H2OCalendar1."Day of Week" := H2OCalendar1."Day of Week"::Saturday;
                    H2OCalendar1."Nonworking Day" := true;
                    H2OCalendar1."Contract Start Time" := 0T;
                    H2OCalendar1."Contract End Time" := 0T;
                    H2OCalendar1.ContractST := 0DT;
                    H2OCalendar1.ContractET := 0DT;
                end;

                H2OCalendar1.Month := Date2DMY(DateTbl."Period Start", 2);
                H2OCalendar1.Day := Date2DMY(DateTbl."Period Start", 1);

                H2OCalendar1.insert;
            until DateTbl.next = 0;
    end;


    trigger OnPostReport()
    begin
        message('Done');
    end;
}
