codeunit 50120 "Calc Time Interval"
{
    TableNo = "Sales Line";

    trigger OnRun()
    begin
    end;


    var
        SalesLineOriginal: record "Sales Line";
        SalesLineNew: record "Sales Line";
        WorkType: record "Work Type";
        H2OCal: record "H2O Calendar";
        ElapsedStartTimeDur: Duration;
        ElapsedStartTimeInt: integer;
        ElapsedStartQty: decimal;
        ElapsedStartQtyMOD: integer;
        ElapsedEndTimeDur: Duration;
        ElapsedEndTimeInt: integer;
        ElapsedEndQty: decimal;
        ElapsedEndQtyMOD: integer;
        ElapsedNoOTTimeDur: Duration;
        ElapsedNoOTTimeInt: integer;
        ElapsedNoOTQty: decimal;
        ElapsedNoOTQtyMOD: integer;
        ElapsedOverniteQty: decimal;
        ElapsedOverniteQtyMOD: integer;
        ElapsedOverniteTimeInt: integer;
        ElapsedOverniteTimeDur: duration;
        ElapsedManyDayQty: decimal;
        ElapsedManyDayQtyMOD: integer;
        ElapsedManyDayTimeInt: integer;
        ElapsedManyDayTimeDur: duration;
        BeforeEarly: boolean;
        BeforeLate: Boolean;
        AfterEarly: boolean;
        AfterLate: boolean;
        SalesInvSubform: page "Sales Invoice Subform";
        Text50004: TextConst ENU = 'End Time must be greater than Start Time.';
        Text50005: TextConst ENU = 'Start Time cannot be blank.';
        Text50006: TextConst ENU = 'End Date must be greater than or equal to Start Date';
        TimeDiffFirstDur: Duration;
        TimeDiffFirstInt: Integer;
        TimeDiffFirstQty: decimal;
        TimeDiffFirstQtyMOD: integer;
        TimeDiffSecondDur: Duration;
        TimeDiffSecondInt: integer;
        TimeDiffSecondQty: decimal;
        TimeDiffSecondQtyMOD: integer;



    // Example - Start Time > 7:30 am and End Time < 4:00 pm
    procedure NormalDay(var SalesLine: record "Sales Line"; SalesHeader: record "Sales Header"; H2OCal: record "H2O Calendar")
    begin
        IF SalesLine."Start Time" = 0T then
            error(Text50005);

        //Start Time > Contract Start Time and End Time < Contract End Time (normal day work)
        ElapsedNoOTTimeDur := SalesLine.EndDT - SalesLine.StartDT;
        ElapsedNoOTTimeInt := ElapsedNoOTTimeDur / 60000;
        ElapsedNoOTQty := ElapsedNoOTTimeInt DIV 15;
        ElapsedNoOTQtyMOD := ElapsedNoOTTimeInt MOD 15;

        //if there is a start and end time remainder
        IF ElapsedNoOTQtyMOD <> 0 then
            ElapsedNoOTQty := (ElapsedNoOTTimeInt DIV 15) + 1;

        //Update the existing entered line
        WorkType.reset;
        WorkType.setrange(Contract, true);
        If WorkType.findfirst then
            SalesLine."Work Type Code" := WorkType.Code;

        SalesLine.validate(Quantity, ElapsedNoOTQty / 4);
        SalesLine.CalcResPrice(SalesLine);
        SalesLine.UpdateMEL;
        SalesLine.modify;
    end;


    // Example - Start Time < 7:30 am and End Time < 4:00 pm
    procedure EarlyStartContractEnd(var SalesLine: record "Sales Line"; SalesHeader: record "Sales Header"; H2OCal: record "H2O Calendar")
    begin
        BeforeEarly := true;
        AfterLate := false;

        IF SalesLine."Start Time" = 0T then
            error(Text50005);

        clear(SalesLineOriginal);
        SalesLineOriginal := SalesLine;

        // Start Time < Contract Start Time (early morning and daytime work)
        // Example - Start Time = 5:00 am and Contract Time = 7:30 am
        ElapsedStartTimeDur := H2OCal.ContractST - SalesLine.StartDT;
        ElapsedStartTimeInt := ElapsedStartTimeDur / 60000;
        ElapsedStartQty := ElapsedStartTimeInt DIV 15;
        ElapsedStartQtyMOD := ElapsedStartTimeInt MOD 15;

        //if there is a start time remainder
        IF ElapsedStartQtyMOD <> 0 then
            ElapsedStartQty := (ElapsedStartTimeInt DIV 15) + 1;

        // end time is before contract end time (daytime work)
        // Example - end time is 2:00 pm and contract end time is 4:00 pm
        ElapsedEndTimeDur := SalesLine."End Time" - SalesLine."Start Time" - ElapsedStartTimeDur;
        ElapsedEndTimeInt := ElapsedEndTimeDur / 60000;
        ElapsedEndQty := ElapsedEndTimeInt DIV 15;
        ElapsedEndQtyMOD := ElapsedEndTimeInt MOD 15;

        //if there is an end time remainder
        IF ElapsedEndQtyMOD <> 0 then
            ElapsedEndQty := (ElapsedEndTimeInt DIV 15) + 1;

        //create a new overtime line for early
        If BeforeEarly then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 100;
            SalesLineNew.UpdateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Overtime, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLine."Start Date";
            SalesLineNew."Start Time" := SalesLine."Start Time";
            SalesLineNew."End Date" := SalesLine."End Date";
            SalesLineNew."End Time" := H2OCal."Contract Start Time";
            SalesLineNew.validate(Quantity, ElapsedStartQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.UpdateMEL;
            SalesLineNew.modify(false);

            //update existing (entered) contract line
            WorkType.reset;
            WorkType.setrange(Contract, true);
            If WorkType.findfirst then
                SalesLine."Work Type Code" := WorkType.Code;
            SalesLine."Start Date" := SalesLine."Start Date";
            SalesLine."Start Time" := H2OCal."Contract Start Time";
            SalesLine."End Date" := SalesLine."End Date";
            SalesLine."End Time" := SalesLine."End Time";
            SalesLine.validate(Quantity, ElapsedEndQty / 4);
            SalesLine.CalcResPrice(SalesLine);
            SalesLine.updatemel;
            SalesLine.modify;
        end;

        //create a new overtime line for late
        If AfterLate then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 100;
            SalesLineNew.UpdateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Overtime, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLine."Start Date";
            SalesLineNew."Start Time" := SalesLine."Start Time";
            SalesLineNew."End Date" := SalesLine."End Date";
            SalesLineNew."End Time" := H2OCal."Contract End Time";
            SalesLineNew.validate(Quantity, ElapsedStartQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.updatemel;
            SalesLineNew.modify(false);

            //update existing (entered) contract line
            WorkType.reset;
            WorkType.setrange(Contract, true);
            If WorkType.findfirst then
                SalesLine."Work Type Code" := WorkType.Code;
            SalesLine."Start Date" := SalesLine."Start Date";
            SalesLine."Start Time" := H2OCal."Contract Start Time";
            SalesLine."End Date" := SalesLine."End Date";
            SalesLine."End Time" := SalesLine."End Time";
            SalesLine.validate(Quantity, ElapsedEndQty / 4);
            SalesLine.CalcResPrice(SalesLine);
            SalesLine.updatemel;
            SalesLine.modify;
        end;
    end;


    // Example - Start Time < 7:30 am and End Time > 4:00 pm
    procedure EarlyStartLateEnd(var SalesLine: record "Sales Line"; SalesHeader: record "Sales Header"; H2OCal: record "H2O Calendar")
    begin
        BeforeEarly := true;
        AfterLate := true;

        IF SalesLine."Start Time" = 0T then
            error(Text50005);

        clear(SalesLineOriginal);
        SalesLineOriginal := SalesLine;

        // Start Time < Contract Start Time (early morning and daytime work)
        // Example - Start Time = 5:00 am and Contract Time = 7:30 am
        ElapsedStartTimeDur := H2OCal.ContractST - SalesLine.StartDT;
        ElapsedStartTimeInt := ElapsedStartTimeDur / 60000;
        ElapsedStartQty := ElapsedStartTimeInt DIV 15;
        ElapsedStartQtyMOD := ElapsedStartTimeInt MOD 15;

        //if there is a start time remainder
        IF ElapsedStartQtyMOD <> 0 then
            ElapsedStartQty := (ElapsedStartTimeInt DIV 15) + 1;

        // end time is after contract end time (daytime work ending in evening)
        // Example - end time is 2:00 pm and contract end time is 4:00 pm
        ElapsedEndTimeDur := SalesLine."End Time" - SalesLine."Start Time" - ElapsedStartTimeDur;
        ElapsedEndTimeInt := ElapsedEndTimeDur / 60000;
        ElapsedEndQty := ElapsedEndTimeInt DIV 15;
        ElapsedEndQtyMOD := ElapsedEndTimeInt MOD 15;

        //if there is an end time remainder
        IF ElapsedEndQtyMOD <> 0 then
            ElapsedEndQty := (ElapsedEndTimeInt DIV 15) + 1;

        //create an overtime line for starting before Contract Start Time
        If BeforeEarly then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 100;
            SalesLineNew.UpdateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Overtime, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLine."Start Date";
            SalesLineNew."Start Time" := SalesLine."Start Time";
            SalesLineNew."End Date" := SalesLine."End Date";
            SalesLineNew."End Time" := H2OCal."Contract Start Time";
            SalesLineNew.validate(Quantity, ElapsedStartQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.UpdateMEL;
            SalesLineNew.modify(false);
        end;

        //update existing (entered) contract line
        WorkType.reset;
        WorkType.setrange(Contract, true);
        If WorkType.findfirst then
            SalesLine."Work Type Code" := WorkType.Code;
        SalesLine."Start Date" := SalesLine."Start Date";
        SalesLine."Start Time" := H2OCal."Contract Start Time";
        SalesLine."End Date" := SalesLine."End Date";
        SalesLine."End Time" := SalesLine."End Time";
        SalesLine.validate(Quantity, ElapsedEndQty / 4);
        SalesLine.CalcResPrice(SalesLine);
        SalesLine.updatemel;
        SalesLine.modify;

        //create a new overtime line for ending after Contract End Time
        If AfterLate then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 100;
            SalesLineNew.UpdateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Overtime, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLine."Start Date";
            SalesLineNew."Start Time" := SalesLine."Start Time";
            SalesLineNew."End Date" := SalesLine."End Date";
            SalesLineNew."End Time" := H2OCal."Contract End Time";
            SalesLineNew.validate(Quantity, ElapsedStartQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.updatemel;
            SalesLineNew.modify(false);
        end;
    end;



    //End Time > 4:00 pm
    procedure ContractStartLateEnd(var SalesLine: record "Sales Line"; SalesHeader: record "Sales Header"; H2OCal: record "H2O Calendar")
    begin
        BeforeEarly := false;
        AfterLate := true;

        IF SalesLine."Start Time" = 0T then
            error(Text50005);

        clear(SalesLineOriginal);
        SalesLineOriginal := SalesLine;

        // Start Time < Contract End Time (late start)
        // Example - Start Time = 3:00 pm and Contract End Time = 4:00 pm
        ElapsedStartTimeDur := H2OCal.ContractET - SalesLine.StartDT;
        ElapsedStartTimeInt := ElapsedStartTimeDur / 60000;
        ElapsedStartQty := ElapsedStartTimeInt DIV 15;
        ElapsedStartQtyMOD := ElapsedStartTimeInt MOD 15;

        //if there is an start time remainder
        IF ElapsedStartQtyMOD <> 0 then
            ElapsedStartQty := (ElapsedStartTimeInt DIV 15) + 1;

        // End Time > Contract End Time 
        If SalesLine.EndDT > H2OCal.ContractET then begin
            ElapsedEndTimeDur := SalesLine.EndDT - H2OCal.ContractET;
            ElapsedEndTimeInt := ElapsedEndTimeDur / 60000;
            ElapsedEndQty := ElapsedEndTimeInt DIV 15;
            ElapsedEndQtyMOD := ElapsedEndTimeInt MOD 15;

            //if there is a end time remainder
            IF ElapsedEndQtyMOD <> 0 then
                ElapsedEndQty := (ElapsedEndTimeInt DIV 15) + 1;
        end;

        //create an overtime line for starting before Contract Start Time
        IF BeforeEarly then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 100;
            SalesLineNew.updateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Overtime, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLine."Start Date";
            SalesLineNew."Start Time" := H2OCal."Contract End Time";
            SalesLineNew."End Date" := SalesLine."End Date";
            SalesLineNew."End Time" := SalesLine."End Time";
            SalesLineNew.validate(Quantity, ElapsedEndQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.updatemel;
            SalesLineNew.modify(false);
        end;

        //update existing (entered) contract line
        WorkType.reset;
        WorkType.setrange(Contract, true);
        If WorkType.findfirst then
            SalesLine."Work Type Code" := WorkType.Code;
        SalesLine."Start Date" := SalesLine."Start Date";
        SalesLine."Start Time" := SalesLine."Start Time";
        SalesLine."End Date" := SalesLine."End Date";
        SalesLine."End Time" := H2OCal."Contract End Time";
        SalesLine.validate(Quantity, ElapsedStartQty / 4);
        SalesLine.CalcResPrice(SalesLine);
        SalesLine.updatemel;
        SalesLine.modify;

        //create an overtime line for ending after Contract End Time
        IF AfterLate then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 100;
            SalesLineNew.updateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Overtime, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLine."Start Date";
            SalesLineNew."Start Time" := H2OCal."Contract End Time";
            SalesLineNew."End Date" := SalesLine."End Date";
            //SalesLineNew."End Time" := SalesLine."End Time";
            SalesLineNew.validate(Quantity, ElapsedEndQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.updatemel;
            SalesLineNew.modify(false);
        end;
    end;


    // Both Start and End Time > 4:00 pm
    procedure LateStartLateEnd(var SalesLine: record "Sales Line"; SalesHeader: record "Sales Header"; H2OCal: record "H2O Calendar")
    begin
        BeforeEarly := false;
        AfterLate := true;

        IF SalesLine."Start Time" = 0T then
            error(Text50005);

        clear(SalesLineOriginal);
        SalesLineOriginal := SalesLine;

        /*
        // Start Time < Contract End Time (late start)
        // Example - Start Time = 5:00 pm and Contract End Time = 4:00 pm
        If SalesLine.StartDT < H2OCal.ContractET then begin
            ElapsedStartTimeDur := H2OCal.ContractET - SalesLine.StartDT;
            ElapsedStartTimeInt := ElapsedStartTimeDur / 60000;
            ElapsedStartQty := ElapsedStartTimeInt DIV 15;
            ElapsedStartQtyMOD := ElapsedStartTimeInt MOD 15;

            //if there is an start time remainder
            IF ElapsedStartQtyMOD <> 0 then
                ElapsedStartQty := (ElapsedStartTimeInt DIV 15) + 1;
        end;
        */

        // End Time > Contract End Time AND Start Time > Contract End Time
        If (SalesLine.EndDT > H2OCal.ContractET) AND (SalesLine.StartDT > H2OCal.ContractET) then begin
            ElapsedEndTimeDur := SalesLine.EndDT - SalesLine.StartDT;
            ElapsedEndTimeInt := ElapsedEndTimeDur / 60000;
            ElapsedEndQty := ElapsedEndTimeInt DIV 15;
            ElapsedEndQtyMOD := ElapsedEndTimeInt MOD 15;

            //if there is a end time remainder
            IF ElapsedEndQtyMOD <> 0 then
                ElapsedEndQty := (ElapsedEndTimeInt DIV 15) + 1;
        end;

        //create an overtime line for starting before Contract Start Time
        IF BeforeEarly then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 100;
            SalesLineNew.updateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Overtime, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLine."Start Date";
            SalesLineNew."Start Time" := H2OCal."Contract End Time";
            SalesLineNew."End Date" := SalesLine."End Date";
            SalesLineNew."End Time" := SalesLine."End Time";
            SalesLineNew.validate(Quantity, ElapsedEndQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.updatemel;
            SalesLineNew.modify(false);
        end;

        //update existing (entered) line with overtime 
        IF AfterLate then begin
            WorkType.reset;
            WorkType.setrange(Overtime, true);
            If WorkType.findfirst then
                SalesLine."Work Type Code" := WorkType.Code;
            SalesLine."Start Date" := SalesLine."Start Date";
            SalesLine."Start Time" := SalesLine."Start Time";
            SalesLine."End Date" := SalesLine."End Date";
            SalesLine."End Time" := SalesLine."End Time";
            SalesLine.validate(Quantity, ElapsedEndQty / 4);
            SalesLine.CalcResPrice(SalesLine);
            SalesLine.updatemel;
            SalesLine.modify;
        end;


        /* - commented out because there is no secondary line for differing rates
        //create an overtime line for ending after Contract End Time
        IF AfterLate then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 100;
            SalesLineNew.updateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Overtime, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLine."Start Date";
            SalesLineNew."Start Time" := H2OCal."Contract End Time";
            SalesLineNew."End Date" := SalesLine."End Date";
            //SalesLineNew."End Time" := SalesLine."End Time";
            SalesLineNew.validate(Quantity, ElapsedEndQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.updatemel;
            SalesLineNew.modify(false);
        end;
        */
    end;


    //Start Time < 7:30 am and End Time > 4:00 pm
    procedure LongDay(var SalesLine: record "Sales Line"; SalesHeader: record "Sales Header"; H2OCal: record "H2O Calendar")
    begin
        IF SalesLine."Start Time" = 0T then
            error(Text50005);

        clear(SalesLineOriginal);
        SalesLineOriginal := SalesLine;

        // Start Time < Contract Start Time (early morning and daytime work)
        ElapsedStartTimeDur := H2OCal.ContractST - SalesLine.StartDT;
        ElapsedStartTimeInt := ElapsedStartTimeDur / 60000;
        ElapsedStartQty := ElapsedStartTimeInt DIV 15;
        ElapsedStartQtyMOD := ElapsedStartTimeInt MOD 15;
        IF ElapsedStartQty > 0 then
            BeforeEarly := true;

        ElapsedEndTimeDur := SalesLine.EndDT - H2OCal.ContractET;
        ElapsedEndTimeInt := ElapsedEndTimeDur / 60000;
        ElapsedEndQty := ElapsedEndTimeInt DIV 15;
        ElapsedEndQtyMOD := ElapsedEndTimeInt MOD 15;
        If ElapsedEndQty > 0 then
            AfterLate := true;

        ElapsedNoOTTimeDur := SalesLine.EndDT - SalesLine.StartDT - ElapsedStartTimeDur - ElapsedEndTimeDur;
        ElapsedNoOTTimeInt := ElapsedNoOTTimeDur / 60000;
        ElapsedNoOTQty := ElapsedNoOTTimeInt DIV 15;
        ElapsedNoOTQtyMOD := ElapsedNoOTTimeInt MOD 15;

        //create a new overtime line before
        IF BeforeEarly then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 100;
            SalesLineNew.updateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Overtime, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLine."Start Date";
            SalesLineNew."Start Time" := SalesLine."Start Time";
            SalesLineNew."End Date" := SalesLine."End Date";
            SalesLineNew."End Time" := H2OCal."Contract Start Time";
            SalesLineNew.validate(Quantity, ElapsedStartQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.updateMEL;
            SalesLineNew.modify(false);
        end;

        //create a new overtime line after
        IF AfterLate then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 200;
            SalesLineNew.updateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Overtime, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLine."Start Date";
            SalesLineNew."Start Time" := H2OCal."Contract End Time";
            SalesLineNew."End Date" := SalesLine."End Date";
            SalesLineNew."End Time" := SalesLine."End Time";
            SalesLineNew.validate(Quantity, ElapsedEndQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.updateMEL;
            SalesLineNew.modify(false);
        end;

        //update existing (entered) contract line
        WorkType.reset;
        WorkType.setrange(Contract, true);
        If WorkType.findfirst then
            SalesLine."Work Type Code" := WorkType.Code;
        SalesLine."Start Date" := SalesLine."Start Date";
        SalesLine."Start Time" := H2OCal."Contract Start Time";
        SalesLine."End Date" := SalesLine."End Date";
        SalesLine."End Time" := H2OCal."Contract End Time";
        SalesLine.validate(Quantity, ElapsedNoOTQty / 4);
        SalesLine.CalcResPrice(SalesLine);
        SalesLine.updateMEL;
        SalesLine.modify;
    end;


    //Start Time > 4:00 pm and End Time < 7:30 am
    procedure Overnight(var SalesLine: record "Sales Line"; SalesHeader: record "Sales Header"; H2OCal: record "H2O Calendar")
    begin
        IF SalesLine."Start Time" = 0T then
            error(Text50005);

        clear(SalesLineOriginal);
        SalesLineOriginal := SalesLine;

        //Start Time > Contract End Time and End Time < Contract Start Time (overnight)
        ElapsedOverniteTimeDur := SalesLine.EndDT - SalesLine.StartDT;
        ElapsedOverniteTimeInt := ElapsedOverniteTimeDur / 60000;
        ElapsedOverniteQty := ElapsedOverniteTimeInt DIV 15;
        ElapsedOverniteQtyMOD := ElapsedOverniteTimeInt MOD 15;

        //if there is a start and end time remainder
        IF ElapsedOverniteQtyMOD <> 0 then
            ElapsedOverniteQty := (ElapsedOverniteTimeInt DIV 15) + 1;

        //update existing (entered) contract line
        WorkType.reset;
        WorkType.setrange(Overtime, true);
        If WorkType.findfirst then
            SalesLine."Work Type Code" := WorkType.Code;
        SalesLine."Start Date" := SalesLine."Start Date";
        SalesLine."Start Time" := SalesLine."Start Time";
        SalesLine."End Date" := SalesLine."End Date";
        SalesLine."End Time" := SalesLine."End Time";
        SalesLine.validate(Quantity, ElapsedOverniteQty / 4);
        SalesLine.CalcResPrice(SalesLine);
        SalesLine.updateMEL;
        SalesLine.modify;
    end;


    procedure ManyDays(var SalesLine: record "Sales Line"; SalesHeader: record "Sales Header"; H2OCal: record "H2O Calendar"; H2OCalEnd: record "H2O Calendar")
    begin
        IF SalesLine."Start Time" = 0T then
            error(Text50005);

        clear(SalesLineOriginal);
        SalesLineOriginal := SalesLine;

        //Start Time > Contract End Time and End Time < Contract Start Time (overnight)
        ElapsedManyDayTimeDur := SalesLine.EndDT - SalesLine.StartDT;
        ElapsedManyDayTimeInt := ElapsedManyDayTimeDur / 60000;
        ElapsedManyDayQty := ElapsedManyDayTimeInt DIV 15;
        ElapsedManyDayQtyMOD := ElapsedManyDayTimeInt MOD 15;

        //if there is a start and end time remainder
        IF ElapsedManyDayQtyMOD <> 0 then
            ElapsedManyDayQty := (ElapsedManyDayTimeInt DIV 15) + 1;

        IF SalesLine.StartDT > H2OCal.ContractST then begin
            TimeDiffFirstDur := H2OCal.ContractET - SalesLine.StartDT;
            TimeDiffFirstInt := TimeDiffFirstDur / 60000;
            TimeDiffFirstQty := TimeDiffFirstInt DIV 15;
            TimeDiffFirstQtyMOD := TimeDiffFirstInt MOD 15;

            IF TimeDiffFirstQtyMOD <> 0 then
                TimeDiffFirstQty := (TimeDiffFirstInt DIV 15) + 1;

            BeforeEarly := true;
        end;

        IF SalesLine.EndDT < H2OCalEnd.ContractET then begin
            TimeDiffSecondDur := SalesLine.EndDT - H2OCalEnd.ContractST;
            TimeDiffSecondInt := TimeDiffSecondDur / 60000;
            TimeDiffSecondQty := TimeDiffSecondInt DIV 15;
            TimeDiffSecondQtyMOD := TimeDiffSecondInt MOD 15;

            IF TimeDiffSecondQtyMOD <> 0 then
                TimeDiffSecondQty := (TimeDiffSecondInt DIV 15) + 1;

            AfterLate := true;
        end;

        //update existing (entered) contract line
        WorkType.reset;
        WorkType.setrange(Overtime, true);
        If WorkType.findfirst then
            SalesLine."Work Type Code" := WorkType.Code;
        SalesLine."Start Date" := SalesLine."Start Date";
        SalesLine."Start Time" := H2OCal."Contract End Time";
        SalesLine."End Date" := SalesLine."End Date";
        SalesLine."End Time" := H2OCalEnd."Contract Start Time";
        SalesLine.validate(Quantity, (ElapsedManyDayQty - TimeDiffFirstQty - TimeDiffSecondQty) / 4);
        SalesLine.CalcResPrice(SalesLine);
        SalesLine.updateMEL;
        SalesLine.modify;


        IF BeforeEarly then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 100;
            SalesLineNew.updateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Contract, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLineOriginal."Start Date";
            SalesLineNew."Start Time" := SalesLineOriginal."Start Time";
            SalesLineNew."End Date" := SalesLine."Start Date";
            SalesLineNew."End Time" := H2OCal."Contract End Time";
            SalesLineNew.validate(Quantity, TimeDiffFirstQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.updateMEL;
            SalesLineNew.modify(false);
        end;

        IF AfterLate then begin
            SalesLineNew.init;
            SalesLineNew := SalesLineOriginal;
            SalesLineNew."Line No." += 200;
            SalesLineNew.updateMEL;
            SalesLineNew.insert(false);

            WorkType.reset;
            WorkType.setrange(Contract, true);
            If WorkType.findfirst then
                SalesLineNew."Work Type Code" := WorkType.Code;

            SalesLineNew."Start Date" := SalesLine."End Date";
            SalesLineNew."Start Time" := H2OCal."Contract Start Time";
            SalesLineNew."End Date" := SalesLineOriginal."End Date";
            SalesLineNew."End Time" := SalesLineOriginal."End Time";
            SalesLineNew.validate(Quantity, TimeDiffSecondQty / 4);
            SalesLineNew.CalcResPrice(SalesLineNew);
            SalesLineNew.updateMEL;
            SalesLineNew.modify(false);
        end;
    end;

}
