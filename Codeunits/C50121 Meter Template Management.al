codeunit 50121 "Meter Template Management"
{
    Permissions = TableData Meter = rim;


    trigger OnRun()
    begin
    end;

    var
        VATPostingSetupErr: TextConst ENU = 'VAT Posting Setup does not exist. "VAT Bus. Posting Group" = %1, "VAT Prod. Posting Group" = %2.', Comment = '%1 - vat bus. posting group code; %2 - vat prod. posting group code';
        UpdateExistingValuesQst: TextConst ENU = 'You are about to apply the template to selected records. Data from the template will replace data for the records in fields that do not already contain data. Do you want to continue?';
        OpenBlankCardQst: TextConst ENU = 'Do you want to open the blank Meter card?';


    procedure CreateMtrFromTemplate(var Mtr: Record Meter; var IsHandled: Boolean; MtrTemplCode: Code[20]) Result: Boolean
    var
        MtrTempl: Record "Meter Template";
    begin
        IsHandled := false;
        OnBeforeCreateMtrFromTemplate(Mtr, Result, IsHandled);
        if IsHandled then
            exit(Result);

        IsHandled := true;

        OnCreateMtrFromTemplateOnBeforeSelectMtrTemplate(Mtr, MtrTempl);
        if MtrTemplCode = '' then begin
            if not SelectMtrTemplate(MtrTempl) then
                exit(false);
        end
        else
            MtrTempl.Get(MtrTemplCode);

        Mtr.Init();
        InitMtrNo(Mtr, MtrTempl);
        Mtr.Insert(true);

        ApplyMtrTemplate(Mtr, MtrTempl, true);

        OnAfterCreateMtrFromTemplate(Mtr, MtrTempl);
        exit(true);
    end;


    procedure CreateMtrFromTemplate(var Mtr: Record Meter; var IsHandled: Boolean): Boolean
    begin
        exit(CreateMtrFromTemplate(Mtr, IsHandled, ''));
    end;


    procedure ApplyMtrTemplate(var Mtr: Record Meter; MtrTempl: Record "Meter Template")
    begin
        ApplyMtrTemplate(Mtr, MtrTempl, false);
    end;


    procedure ApplyMtrTemplate(var Mtr: Record Meter; MtrTempl: Record "Meter Template"; UpdateExistingValues: Boolean)
    begin
        ApplyTemplate(Mtr, MtrTempl, UpdateExistingValues);
        InsertDimensions(Mtr."No.", MtrTempl.Code, Database::Meter, Database::"Meter Template");
        OnApplyMtrTemplateOnBeforeMtrGet(Mtr, MtrTempl, UpdateExistingValues);
        Mtr.Get(Mtr."No.");
    end;


    local procedure ApplyTemplate(var Mtr: Record Meter; MtrTempl: Record "Meter Template"; UpdateExistingValues: Boolean)
    var
        TempMtr: Record Meter temporary;
        MeterSetup: Record "Meter Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        MtrRecRef: RecordRef;
        EmptyMtrRecRef: RecordRef;
        MtrTemplRecRef: RecordRef;
        EmptyMtrTemplRecRef: RecordRef;
        MtrFldRef: FieldRef;
        EmptyMtrFldRef: FieldRef;
        MtrTemplFldRef: FieldRef;
        EmptyMtrTemplFldRef: FieldRef;
        i: Integer;
        FieldExclusionList: List of [Integer];
        FieldValidationList: List of [Integer];
        IsHandled: Boolean;
    begin
        //CheckMtrTemplRoundingPrecision(MtrTempl);
        MtrRecRef.GetTable(Mtr);
        MeterSetup.Get();
        TempMtr.Init();
        //TempMtr."Costing Method" := InventorySetup."Default Costing Method";
        EmptyMtrRecRef.GetTable(TempMtr);
        MtrTemplRecRef.GetTable(MtrTempl);
        EmptyMtrTemplRecRef.Open(Database::"Meter Template");
        EmptyMtrTemplRecRef.Init();

        FillFieldExclusionList(FieldExclusionList);

        for i := 3 to MtrTemplRecRef.FieldCount do begin
            MtrTemplFldRef := MtrTemplRecRef.FieldIndex(i);
            if TemplateFieldCanBeProcessed(MtrTemplFldRef.Number, FieldExclusionList) then begin
                MtrFldRef := MtrRecRef.Field(MtrTemplFldRef.Number);
                EmptyMtrFldRef := EmptyMtrRecRef.Field(MtrTemplFldRef.Number);
                EmptyMtrTemplFldRef := EmptyMtrTemplRecRef.Field(MtrTemplFldRef.Number);
                if (not UpdateExistingValues and (MtrFldRef.Value = EmptyMtrFldRef.Value) and (MtrTemplFldRef.Value <> EmptyMtrTemplFldRef.Value)) or
                   (UpdateExistingValues and (MtrTemplFldRef.Value <> EmptyMtrTemplFldRef.Value))
                then begin
                    MtrFldRef.Value := MtrTemplFldRef.Value;
                    FieldValidationList.Add(MtrTemplFldRef.Number);
                end;
            end;
        end;

        OnApplyTemplateOnBeforeValidateFields(MtrRecRef, MtrTemplRecRef, FieldExclusionList, FieldValidationList);

        for i := 1 to FieldValidationList.Count do begin
            MtrTemplFldRef := MtrTemplRecRef.Field(FieldValidationList.Get(i));
            MtrFldRef := MtrRecRef.Field(MtrTemplFldRef.Number);
            MtrFldRef.Validate(MtrTemplFldRef.Value);
        end;

        MtrRecRef.SetTable(Mtr);
        //SetBaseUoM(Mtr, MtrTempl);
        //if MtrTempl."Price Includes VAT" then begin
        //    SalesReceivablesSetup.Get();
        //    if not VATPostingSetup.Get(SalesReceivablesSetup."VAT Bus. Posting Gr. (Price)", MtrTempl."VAT Prod. Posting Group") then
        //        Error(VATPostingSetupErr, SalesReceivablesSetup."VAT Bus. Posting Gr. (Price)", MtrTempl."VAT Prod. Posting Group");
        //    Mtr.Validate("Price Includes VAT", MtrTempl."Price Includes VAT");
        //end;
        //Mtr.Validate("Meter Category Code", MtrTempl."Meter Category Code");
        Mtr.validate("Meter Group Code", MtrTempl."Meter Group Code");

        IsHandled := false;
        OnApplyTemplateOnBeforeMtrModify(Mtr, MtrTempl, IsHandled);
        if not IsHandled then
            Mtr.Modify(true);
    end;


    local procedure SelectMtrTemplate(var MtrTempl: Record "Meter Template"): Boolean
    var
        SelectMtrTemplList: Page "Select Meter Templ. List";
        IsHandled: Boolean;
        Result: Boolean;
    begin
        IsHandled := false;
        OnBeforeSelectMtrTemplate(MtrTempl, IsHandled, Result);
        if IsHandled then
            exit(Result);

        if MtrTempl.Count = 1 then begin
            MtrTempl.FindFirst();
            exit(true);
        end;

        if (MtrTempl.Count > 1) and GuiAllowed then begin
            SelectMtrTemplList.SetTableView(MtrTempl);
            SelectMtrTemplList.LookupMode(true);
            if SelectMtrTemplList.RunModal() = Action::LookupOK then begin
                SelectMtrTemplList.GetRecord(MtrTempl);
                exit(true);
            end;
        end;

        exit(false);
    end;


    procedure InsertDimensions(DestNo: Code[20]; SourceNo: Code[20]; DestTableId: Integer; SourceTableId: Integer)
    var
        SourceDefaultDimension: Record "Default Dimension";
        DestDefaultDimension: Record "Default Dimension";
    begin
        SourceDefaultDimension.SetRange("Table ID", SourceTableId);
        SourceDefaultDimension.SetRange("No.", SourceNo);
        if SourceDefaultDimension.FindSet() then
            repeat
                DestDefaultDimension.Init();
                DestDefaultDimension.Validate("Table ID", DestTableId);
                DestDefaultDimension.Validate("No.", DestNo);
                DestDefaultDimension.Validate("Dimension Code", SourceDefaultDimension."Dimension Code");
                DestDefaultDimension.Validate("Dimension Value Code", SourceDefaultDimension."Dimension Value Code");
                DestDefaultDimension.Validate("Value Posting", SourceDefaultDimension."Value Posting");
                if not DestDefaultDimension.Get(DestDefaultDimension."Table ID", DestDefaultDimension."No.", DestDefaultDimension."Dimension Code") then
                    DestDefaultDimension.Insert(true)
                else
                    if DestDefaultDimension."Value Posting" = DestDefaultDimension."Value Posting"::" " then begin
                        DestDefaultDimension."Value Posting" := SourceDefaultDimension."Value Posting";
                        DestDefaultDimension.Modify(true);
                    end;
            until SourceDefaultDimension.Next() = 0;
    end;


    procedure MtrTemplatesAreNotEmpty(var IsHandled: Boolean): Boolean
    var
        MtrTempl: Record "Meter Template";
        TemplateFeatureMgt: Codeunit "Template Feature Mgt.";
    begin
        if not TemplateFeatureMgt.IsEnabled() then
            exit(false);

        IsHandled := true;
        exit(not MtrTempl.IsEmpty);
    end;


    procedure InsertMtrFromTemplate(var Mtr: Record Meter) Result: Boolean
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnInsertMtrFromTemplate(Mtr, Result, IsHandled);
        if IsHandled then
            exit(Result);

        Result := CreateMtrFromTemplate(Mtr, IsHandled);
    end;


    procedure TemplatesAreNotEmpty() Result: Boolean
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnTemplatesAreNotEmpty(Result, IsHandled);
        if IsHandled then
            exit(Result);

        Result := MtrTemplatesAreNotEmpty(IsHandled);
    end;



    procedure IsEnabled() Result: Boolean
    var
        TemplateFeatureMgt: Codeunit "Template Feature Mgt.";
    begin
        Result := TemplateFeatureMgt.IsEnabled();

        OnAfterIsEnabled(Result);
    end;


    procedure UpdateMtrFromTemplate(var Mtr: Record Meter)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnUpdateMtrFromTemplate(Mtr, IsHandled);
        if IsHandled then
            exit;

        UpdateFromTemplate(Mtr, IsHandled);
    end;

    local procedure UpdateFromTemplate(var Mtr: Record Meter; var IsHandled: Boolean)
    var
        MtrTempl: Record "Meter Template";
    begin
        IsHandled := false;
        OnBeforeUpdateFromTemplate(Mtr, IsHandled);
        if IsHandled then
            exit;

        if not CanBeUpdatedFromTemplate(MtrTempl, IsHandled) then
            exit;

        ApplyMtrTemplate(Mtr, MtrTempl, GetUpdateExistingValuesParam());
    end;



    //procedure UpdateResFromTemplate(var Mtr: Record Meter)
    //var
    //    IsHandled: Boolean;
    //begin
    //    IsHandled := false;
    //    OnUpdateResFromTemplate(Mtr, IsHandled);
    //    if IsHandled then
    //        exit;
    //
    //    UpdateMultipleFromTemplate(Mtr, IsHandled);
    //end;


    local procedure UpdateMultipleFromTemplate(var Mtr: Record Meter; var IsHandled: Boolean)
    var
        MtrTempl: Record "Meter Template";
    begin
        IsHandled := false;
        OnBeforeUpdateMultipleFromTemplate(Mtr, IsHandled);
        if IsHandled then
            exit;

        if not CanBeUpdatedFromTemplate(MtrTempl, IsHandled) then
            exit;

        if Mtr.FindSet() then
            repeat
                ApplyMtrTemplate(Mtr, MtrTempl, GetUpdateExistingValuesParam());
            until Mtr.Next() = 0;
    end;


    local procedure CanBeUpdatedFromTemplate(var MtrTempl: Record "Meter Template"; var IsHandled: Boolean): Boolean
    begin
        IsHandled := true;

        if not SelectMtrTemplate(MtrTempl) then
            exit(false);

        exit(true);
    end;


    procedure SaveAsTemplate(Mtr: Record Meter)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnSaveAsTemplate(Mtr, IsHandled);
        if IsHandled then
            exit;

        CreateTemplateFromRes(Mtr, IsHandled);
    end;


    procedure CreateTemplateFromRes(Mtr: Record Meter; var IsHandled: Boolean)
    var
        MtrTempl: Record "Meter Template";
    begin
        IsHandled := false;
        OnBeforeCreateTemplateFromMtr(Mtr, IsHandled);
        if IsHandled then
            exit;

        IsHandled := true;

        InsertTemplateFromMtr(MtrTempl, Mtr);
        InsertDimensions(MtrTempl.Code, Mtr."No.", Database::"Meter Template", Database::Meter);
        OnCreateTemplateFromMtrOnBeforeMtrTemplGet(Mtr, MtrTempl);
        MtrTempl.Get(MtrTempl.Code);
        ShowMtrTemplCard(MtrTempl);
    end;


    local procedure InsertTemplateFromMtr(var MtrTempl: Record "Meter Template"; Mtr: Record Meter)
    var
        SavedMtrTempl: Record "Meter Template";
    begin
        MtrTempl.Init();
        MtrTempl.Code := GetMtrTemplCode();
        SavedMtrTempl := MtrTempl;
        MtrTempl.TransferFields(Mtr);
        MtrTempl.Code := SavedMtrTempl.Code;
        MtrTempl.Description := SavedMtrTempl.Description;
        OnInsertTemplateFromMtrOnBeforeMtrTemplInsert(MtrTempl, Mtr);
        MtrTempl.Insert();
    end;


    local procedure GetMtrTemplCode() MtrTemplCode: Code[20]
    var
        Mtr: Record Meter;
        MtrTempl: Record "Meter Template";
    begin
        if MtrTempl.FindLast() and (IncStr(MtrTempl.Code) <> '') then
            MtrTemplCode := MtrTempl.Code
        else
            MtrTemplCode := CopyStr(Mtr.TableCaption(), 1, 4) + '000001';

        while MtrTempl.Get(MtrTemplCode) do
            MtrTemplCode := IncStr(MtrTemplCode);
    end;


    local procedure ShowMtrTemplCard(MtrTempl: Record "Meter Template")
    var
        MtrTemplCard: Page "Meter Template Card";
    begin
        if not GuiAllowed then
            exit;

        Commit();
        MtrTemplCard.SetRecord(MtrTempl);
        MtrTemplCard.LookupMode := true;
        if MtrTemplCard.RunModal() = Action::LookupCancel then begin
            MtrTempl.Get(MtrTempl.Code);
            MtrTempl.Delete(true);
        end;
    end;


    procedure ShowTemplates()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnShowTemplates(IsHandled);
        if IsHandled then
            exit;

        ShowMtrTemplList(IsHandled);
    end;


    local procedure ShowMtrTemplList(var IsHandled: Boolean)
    begin
        IsHandled := true;
        Page.Run(Page::"Meter Template List");
    end;


    local procedure InitMtrNo(var Mtr: Record Meter; MtrTempl: Record "Meter Template")
    var
        NoSeries: Codeunit "No. Series";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInitMtrNo(Mtr, MtrTempl, IsHandled);
        if IsHandled then
            exit;

        if MtrTempl."No. Series" = '' then
            exit;

        //NoSeriesManagement.InitSeries(MtrTempl."No. Series", '', 0D, Mtr."No.", Mtr."No. Series");
        NoSeries.TestAutomatic(Mtr."No. Series");

    end;



    //local procedure GetUnitOfMeasureCode(): Code[10]
    //var
    //    UnitOfMeasure: Record "Unit of Measure";
    //begin
    //    UnitOfMeasure.SetRange("International Standard Code", 'EA');
    //    if UnitOfMeasure.FindFirst() then
    //        exit(UnitOfMeasure.Code);

    //    UnitOfMeasure.SetRange("International Standard Code");
    //    if UnitOfMeasure.FindFirst() then
    //        exit(UnitOfMeasure.Code);

    //    exit('');
    //end;



    local procedure TemplateFieldCanBeProcessed(FieldNumber: Integer; FieldExclusionList: List of [Integer]): Boolean
    var
        MtrField: Record Field;
        MtrTemplateField: Record Field;
    begin
        if FieldExclusionList.Contains(FieldNumber) or (FieldNumber > 2000000000) then
            exit(false);

        if not (MtrField.Get(Database::Meter, FieldNumber) and MtrTemplateField.Get(Database::"Meter Template", FieldNumber)) then
            exit(false);

        if (MtrField.Class <> MtrField.Class::Normal) or (MtrTemplateField.Class <> MtrTemplateField.Class::Normal) or
            (MtrField.Type <> MtrTemplateField.Type) or (MtrField.FieldName <> MtrTemplateField.FieldName) or
            (MtrField.Len <> MtrTemplateField.Len) or
            (MtrField.ObsoleteState = MtrField.ObsoleteState::Removed) or
            (MtrTemplateField.ObsoleteState = MtrTemplateField.ObsoleteState::Removed)
        then
            exit(false);

        exit(true);
    end;


    local procedure FillFieldExclusionList(var FieldExclusionList: List of [Integer])
    var
        MtrTempl: Record "Meter Template";
    begin
        //FieldExclusionList.Add(MtrTempl.FieldNo("Base Unit of Measure"));
        FieldExclusionList.Add(MtrTempl.FieldNo("No. Series"));
        //FieldExclusionList.Add(MtrTempl.FieldNo("VAT Bus. Posting Gr. (Price)"));
        FieldExclusionList.Add(MtrTempl.FieldNo("Meter Group Code"));
        //FieldExclusionList.add(MtrTempl.FieldNo("Meter Group Codeo."));

        OnAfterFillFieldExclusionList(FieldExclusionList);
    end;


    local procedure GetUpdateExistingValuesParam() Result: Boolean
    var
        ConfirmManagement: Codeunit "Confirm Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetUpdateExistingValuesParam(Result, IsHandled);
        if not IsHandled then
            Result := ConfirmManagement.GetResponseOrDefault(UpdateExistingValuesQst, false);
    end;


    //local procedure SetBaseUoM(var Mtr: Record Meter; var MtrTempl: Record "Meter Template")
    //var
    //    IsHandled: Boolean;
    //begin
    //    IsHandled := false;
    //    OnBeforeSetBaseUoM(Mtr, MtrTempl, IsHandled);
    //    if IsHandled then
    //        exit;

    //    if MtrTempl."Base Unit of Measure" <> '' then
    //        Mtr.Validate("Base Unit of Measure", MtrTempl."Base Unit of Measure")
    //    else
    //        Mtr.Validate("Base Unit of Measure", GetUnitOfMeasureCode());
    //end;



    //local procedure CheckMtrTemplRoundingPrecision(var MtrTempl: Record "Meter Template")
    //var
    //    ModifyTemplate: Boolean;
    //begin
    //    if MtrTempl."Rounding Precision" = 0 then begin
    //        MtrTempl."Rounding Precision" := 1;
    //        ModifyTemplate := true;
    //    end;
    //    if (MtrTempl.Type = MtrTempl.Type::Service) and (MtrTempl.Reserve <> MtrTempl.Reserve::Never) then begin
    //        MtrTempl.Reserve := MtrTempl.Reserve::Never;
    //        ModifyTemplate := true;
    //    end;
    //    if ModifyTemplate then
    //        MtrTempl.Modify();
    //end;


    procedure IsOpenBlankCardConfirmed(): Boolean
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        exit(ConfirmManagement.GetResponse(OpenBlankCardQst, false));
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterIsEnabled(var Result: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnApplyTemplateOnBeforeMtrModify(var Mtr: Record Meter; MtrTempl: Record "Meter Template"; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnApplyMtrTemplateOnBeforeMtrGet(var Mtr: Record Meter; MtrTempl: Record "Meter Template"; UpdateExistingValues: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnCreateMtrFromTemplateOnBeforeSelectMtrTemplate(Mtr: Record Meter; var MtrTempl: Record "Meter Template")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnInsertMtrFromTemplate(var Mtr: Record Meter; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnTemplatesAreNotEmpty(var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateMtrFromTemplate(var Mtr: Record Meter; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnSaveAsTemplate(Mtr: Record Meter; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnShowTemplates(var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterFillFieldExclusionList(var FieldExclusionList: List of [Integer])
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateMtrFromTemplate(var Mtr: Record Meter; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateFromTemplate(var Mtr: Record Meter; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateMultipleFromTemplate(var Mtr: Record Meter; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateTemplateFromMtr(Mtr: Record Meter; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnInsertTemplateFromMtrOnBeforeMtrTemplInsert(var MtrTempl: Record "Meter Template"; Mtr: Record Meter)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetUpdateExistingValuesParam(var Result: Boolean; var IsHandled: Boolean)
    begin
    end;


    //[IntegrationEvent(false, false)]
    //local procedure OnBeforeSetBaseUoM(var Mtr: Record Meter; var MtrTempl: Record "Meter Template"; var IsHandled: Boolean)
    //begin
    //end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Config. Template Management", 'OnBeforeInsertRecordWithKeyFields', '', false, false)]
    local procedure OnBeforeInsertRecordWithKeyFieldsHandler(var RecRef: RecordRef; ConfigTemplateHeader: Record "Config. Template Header")
    begin
        FillMtrKeyFromInitSeries(RecRef, ConfigTemplateHeader)
    end;


    procedure FillMtrKeyFromInitSeries(var RecRef: RecordRef; ConfigTemplateHeader: Record "Config. Template Header")
    var
        Mtr: Record Meter;
        NoSeries: Codeunit "No. Series";
        FldRef: FieldRef;
    begin
        if RecRef.Number = Database::Meter then begin
            if ConfigTemplateHeader."Instance No. Series" = '' then
                exit;

            //NoSeriesManagement.InitSeries(ConfigTemplateHeader."Instance No. Series", '', 0D, Mtr."No.", Mtr."No. Series");
            NoSeries.TestAutomatic(ConfigTemplateHeader."Instance No. Series");
            FldRef := RecRef.Field(Mtr.FieldNo("No."));
            FldRef.Value := Mtr."No.";
            FldRef := RecRef.Field(Mtr.FieldNo("No. Series"));
            FldRef.Value := Mtr."No. Series";
        end;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitMtrNo(var Mtr: Record Meter; MtrTempl: Record "Meter Template"; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnCreateTemplateFromMtrOnBeforeMtrTemplGet(Mtr: Record Meter; MtrTempl: Record "Meter Template")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateMtrFromTemplate(var Mtr: Record Meter; MtrTempl: Record "Meter Template");
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnApplyTemplateOnBeforeValidateFields(var MtrRecRef: RecordRef; var MtrTemplRecRef: RecordRef; FieldExclusionList: List of [Integer]; var FieldValidationList: List of [Integer])
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeSelectMtrTemplate(MtrTempl: Record "Meter Template"; var IsHandled: Boolean; var Result: Boolean)
    begin
    end;
}
