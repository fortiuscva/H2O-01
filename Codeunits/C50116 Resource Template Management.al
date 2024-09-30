codeunit 50116 "Resource Template Management"
{
    Permissions = TableData Resource = rim,
                tabledata "Resource Attribute" = r,
                tabledata "Resource Attribute Value" = r,
                tabledata "Resource Attribute Translation" = r,
                tabledata "Res. Attribute Value Selection" = r,
                tabledata "Res. Attribute Value Mapping" = r;


    trigger OnRun()
    begin
    end;

    var
        VATPostingSetupErr: TextConst ENU = 'VAT Posting Setup does not exist. "VAT Bus. Posting Group" = %1, "VAT Prod. Posting Group" = %2.', Comment = '%1 - vat bus. posting group code; %2 - vat prod. posting group code';
        UpdateExistingValuesQst: TextConst ENU = 'You are about to apply the template to selected records. Data from the template will replace data for the records in fields that do not already contain data. Do you want to continue?';
        OpenBlankCardQst: TextConst ENU = 'Do you want to open the blank resource card?';


    procedure CreateResFromTemplate(var Res: Record Resource; var IsHandled: Boolean; ResTemplCode: Code[20]) Result: Boolean
    var
        ResTempl: Record "Resource Template";
    begin
        IsHandled := false;
        OnBeforeCreateResFromTemplate(Res, Result, IsHandled);
        if IsHandled then
            exit(Result);

        IsHandled := true;

        OnCreateResFromTemplateOnBeforeSelectResTemplate(Res, ResTempl);
        if ResTemplCode = '' then begin
            if not SelectResTemplate(ResTempl) then
                exit(false);
        end
        else
            ResTempl.Get(ResTemplCode);

        Res.Init();
        InitResNo(Res, ResTempl);
        Res.Insert(true);

        ApplyResTemplate(Res, ResTempl, true);

        OnAfterCreateResFromTemplate(Res, ResTempl);
        exit(true);
    end;


    procedure CreateResFromTemplate(var Res: Record Resource; var IsHandled: Boolean): Boolean
    begin
        exit(CreateResFromTemplate(Res, IsHandled, ''));
    end;

    procedure ApplyResTemplate(var Res: Record Resource; ResTempl: Record "Resource Template")
    begin
        ApplyResTemplate(Res, ResTempl, false);
    end;


    procedure ApplyResTemplate(var Res: Record Resource; ResTempl: Record "Resource Template"; UpdateExistingValues: Boolean)
    begin
        ApplyTemplate(Res, ResTempl, UpdateExistingValues);
        InsertDimensions(Res."No.", ResTempl.Code, Database::Resource, Database::"Resource Template");
        OnApplyResTemplateOnBeforeResGet(Res, ResTempl, UpdateExistingValues);
        Res.Get(Res."No.");
    end;


    local procedure ApplyTemplate(var Res: Record Resource; ResTempl: Record "Resource Template"; UpdateExistingValues: Boolean)
    var
        TempRes: Record Resource temporary;
        ResourcesSetup: Record "Resources Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        ResRecRef: RecordRef;
        EmptyResRecRef: RecordRef;
        ResTemplRecRef: RecordRef;
        EmptyResTemplRecRef: RecordRef;
        ResFldRef: FieldRef;
        EmptyResFldRef: FieldRef;
        ResTemplFldRef: FieldRef;
        EmptyResTemplFldRef: FieldRef;
        i: Integer;
        FieldExclusionList: List of [Integer];
        FieldValidationList: List of [Integer];
        IsHandled: Boolean;
    begin
        //CheckResTemplRoundingPrecision(ResTempl);
        ResRecRef.GetTable(Res);
        ResourcesSetup.Get();
        TempRes.Init();
        //TempRes."Costing Method" := InventorySetup."Default Costing Method";
        EmptyResRecRef.GetTable(TempRes);
        ResTemplRecRef.GetTable(ResTempl);
        EmptyResTemplRecRef.Open(Database::"Resource Template");
        EmptyResTemplRecRef.Init();

        FillFieldExclusionList(FieldExclusionList);

        for i := 3 to ResTemplRecRef.FieldCount do begin
            ResTemplFldRef := ResTemplRecRef.FieldIndex(i);
            if TemplateFieldCanBeProcessed(ResTemplFldRef.Number, FieldExclusionList) then begin
                ResFldRef := ResRecRef.Field(ResTemplFldRef.Number);
                EmptyResFldRef := EmptyResRecRef.Field(ResTemplFldRef.Number);
                EmptyResTemplFldRef := EmptyResTemplRecRef.Field(ResTemplFldRef.Number);
                if (not UpdateExistingValues and (ResFldRef.Value = EmptyResFldRef.Value) and (ResTemplFldRef.Value <> EmptyResTemplFldRef.Value)) or
                   (UpdateExistingValues and (ResTemplFldRef.Value <> EmptyResTemplFldRef.Value))
                then begin
                    ResFldRef.Value := ResTemplFldRef.Value;
                    FieldValidationList.Add(ResTemplFldRef.Number);
                end;
            end;
        end;

        OnApplyTemplateOnBeforeValidateFields(ResRecRef, ResTemplRecRef, FieldExclusionList, FieldValidationList);

        for i := 1 to FieldValidationList.Count do begin
            ResTemplFldRef := ResTemplRecRef.Field(FieldValidationList.Get(i));
            ResFldRef := ResRecRef.Field(ResTemplFldRef.Number);
            ResFldRef.Validate(ResTemplFldRef.Value);
        end;

        ResRecRef.SetTable(Res);
        SetBaseUoM(Res, ResTempl);
        //if ResTempl."Price Includes VAT" then begin
        //    SalesReceivablesSetup.Get();
        //    if not VATPostingSetup.Get(SalesReceivablesSetup."VAT Bus. Posting Gr. (Price)", ResTempl."VAT Prod. Posting Group") then
        //        Error(VATPostingSetupErr, SalesReceivablesSetup."VAT Bus. Posting Gr. (Price)", ResTempl."VAT Prod. Posting Group");
        //    Res.Validate("Price Includes VAT", ResTempl."Price Includes VAT");
        //end;
        Res.Validate("Resource Category Code", ResTempl."Resource Category Code");
        Res.validate("Resource Group No.", ResTempl."Resource Group No.");
        Res.Validate("Indirect Cost %", ResTempl."Indirect Cost %");
        IsHandled := false;
        OnApplyTemplateOnBeforeResModify(Res, ResTempl, IsHandled);
        if not IsHandled then
            Res.Modify(true);
    end;


    local procedure SelectResTemplate(var ResTempl: Record "Resource Template"): Boolean
    var
        SelectResTemplList: Page "Select Resource Templ. List";
        IsHandled: Boolean;
        Result: Boolean;
    begin
        IsHandled := false;
        OnBeforeSelectResTemplate(ResTempl, IsHandled, Result);
        if IsHandled then
            exit(Result);

        if ResTempl.Count = 1 then begin
            ResTempl.FindFirst();
            exit(true);
        end;

        if (ResTempl.Count > 1) and GuiAllowed then begin
            SelectResTemplList.SetTableView(ResTempl);
            SelectResTemplList.LookupMode(true);
            if SelectResTemplList.RunModal() = Action::LookupOK then begin
                SelectResTemplList.GetRecord(ResTempl);
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


    procedure ResTemplatesAreNotEmpty(var IsHandled: Boolean): Boolean
    var
        ResTempl: Record "Resource Template";
        TemplateFeatureMgt: Codeunit "Template Feature Mgt.";
    begin
        if not TemplateFeatureMgt.IsEnabled() then
            exit(false);

        IsHandled := true;
        exit(not ResTempl.IsEmpty);
    end;


    procedure InsertResFromTemplate(var Res: Record Resource) Result: Boolean
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnInsertResFromTemplate(Res, Result, IsHandled);
        if IsHandled then
            exit(Result);

        Result := CreateResFromTemplate(Res, IsHandled);
    end;


    procedure TemplatesAreNotEmpty() Result: Boolean
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnTemplatesAreNotEmpty(Result, IsHandled);
        if IsHandled then
            exit(Result);

        Result := ResTemplatesAreNotEmpty(IsHandled);
    end;

    procedure IsEnabled() Result: Boolean
    var
        TemplateFeatureMgt: Codeunit "Template Feature Mgt.";
    begin
        Result := TemplateFeatureMgt.IsEnabled();

        OnAfterIsEnabled(Result);
    end;


    procedure UpdateResFromTemplate(var Res: Record Resource)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnUpdateResFromTemplate(Res, IsHandled);
        if IsHandled then
            exit;

        UpdateFromTemplate(Res, IsHandled);
    end;


    local procedure UpdateFromTemplate(var Res: Record Resource; var IsHandled: Boolean)
    var
        ResTempl: Record "Resource Template";
    begin
        IsHandled := false;
        OnBeforeUpdateFromTemplate(Res, IsHandled);
        if IsHandled then
            exit;

        if not CanBeUpdatedFromTemplate(ResTempl, IsHandled) then
            exit;

        ApplyResTemplate(Res, ResTempl, GetUpdateExistingValuesParam());
    end;


    /*
    procedure UpdateResFromTemplate(var Res: Record Resource)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnUpdateResFromTemplate(Res, IsHandled);
        if IsHandled then
            exit;

        UpdateMultipleFromTemplate(Res, IsHandled);
    end;
    */


    local procedure UpdateMultipleFromTemplate(var Res: Record Resource; var IsHandled: Boolean)
    var
        ResTempl: Record "Resource Template";
    begin
        IsHandled := false;
        OnBeforeUpdateMultipleFromTemplate(Res, IsHandled);
        if IsHandled then
            exit;

        if not CanBeUpdatedFromTemplate(ResTempl, IsHandled) then
            exit;

        if Res.FindSet() then
            repeat
                ApplyResTemplate(Res, ResTempl, GetUpdateExistingValuesParam());
            until Res.Next() = 0;
    end;


    local procedure CanBeUpdatedFromTemplate(var ResTempl: Record "Resource Template"; var IsHandled: Boolean): Boolean
    begin
        IsHandled := true;

        if not SelectResTemplate(ResTempl) then
            exit(false);

        exit(true);
    end;


    procedure SaveAsTemplate(Res: Record Resource)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnSaveAsTemplate(Res, IsHandled);
        if IsHandled then
            exit;

        CreateTemplateFromRes(Res, IsHandled);
    end;


    procedure CreateTemplateFromRes(Res: Record Resource; var IsHandled: Boolean)
    var
        ResTempl: Record "Resource Template";
    begin
        IsHandled := false;
        OnBeforeCreateTemplateFromRes(Res, IsHandled);
        if IsHandled then
            exit;

        IsHandled := true;

        InsertTemplateFromRes(ResTempl, Res);
        InsertDimensions(ResTempl.Code, Res."No.", Database::"Resource Template", Database::Resource);
        OnCreateTemplateFromResOnBeforeResTemplGet(Res, ResTempl);
        ResTempl.Get(ResTempl.Code);
        ShowResTemplCard(ResTempl);
    end;


    local procedure InsertTemplateFromRes(var ResTempl: Record "Resource Template"; Res: Record Resource)
    var
        SavedResTempl: Record "Resource Template";
    begin
        ResTempl.Init();
        ResTempl.Code := GetResTemplCode();
        SavedResTempl := ResTempl;
        ResTempl.TransferFields(Res);
        ResTempl.Code := SavedResTempl.Code;
        ResTempl.Description := SavedResTempl.Description;
        OnInsertTemplateFromResOnBeforeResTemplInsert(ResTempl, Res);
        ResTempl.Insert();
    end;


    local procedure GetResTemplCode() ResTemplCode: Code[20]
    var
        Res: Record Resource;
        ResTempl: Record "Resource Template";
    begin
        if ResTempl.FindLast() and (IncStr(ResTempl.Code) <> '') then
            ResTemplCode := ResTempl.Code
        else
            ResTemplCode := CopyStr(Res.TableCaption(), 1, 4) + '000001';

        while ResTempl.Get(ResTemplCode) do
            ResTemplCode := IncStr(ResTemplCode);
    end;


    local procedure ShowResTemplCard(ResTempl: Record "Resource Template")
    var
        ResTemplCard: Page "Resource Template Card";
    begin
        if not GuiAllowed then
            exit;

        Commit();
        ResTemplCard.SetRecord(ResTempl);
        ResTemplCard.LookupMode := true;
        if ResTemplCard.RunModal() = Action::LookupCancel then begin
            ResTempl.Get(ResTempl.Code);
            ResTempl.Delete(true);
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

        ShowResTemplList(IsHandled);
    end;


    local procedure ShowResTemplList(var IsHandled: Boolean)
    begin
        IsHandled := true;
        Page.Run(Page::"Resource Template List");
    end;


    local procedure InitResNo(var Res: Record Resource; ResTempl: Record "Resource Template")
    var
        NoSeries: Codeunit "No. Series";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInitResNo(Res, ResTempl, IsHandled);
        if IsHandled then
            exit;

        if ResTempl."No. Series" = '' then
            exit;

        //NoSeriesManagement.InitSeries(ResTempl."No. Series", '', 0D, Res."No.", Res."No. Series");
        NoSeries.TestAutomatic(Res."No. Series");
    end;


    local procedure GetUnitOfMeasureCode(): Code[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        UnitOfMeasure.SetRange("International Standard Code", 'EA');
        if UnitOfMeasure.FindFirst() then
            exit(UnitOfMeasure.Code);

        UnitOfMeasure.SetRange("International Standard Code");
        if UnitOfMeasure.FindFirst() then
            exit(UnitOfMeasure.Code);

        exit('');
    end;


    local procedure TemplateFieldCanBeProcessed(FieldNumber: Integer; FieldExclusionList: List of [Integer]): Boolean
    var
        ResField: Record Field;
        ResTemplateField: Record Field;
    begin
        if FieldExclusionList.Contains(FieldNumber) or (FieldNumber > 2000000000) then
            exit(false);

        if not (ResField.Get(Database::Resource, FieldNumber) and ResTemplateField.Get(Database::"Resource Template", FieldNumber)) then
            exit(false);

        if (ResField.Class <> ResField.Class::Normal) or (ResTemplateField.Class <> ResTemplateField.Class::Normal) or
            (ResField.Type <> ResTemplateField.Type) or (ResField.FieldName <> ResTemplateField.FieldName) or
            (ResField.Len <> ResTemplateField.Len) or
            (ResField.ObsoleteState = ResField.ObsoleteState::Removed) or
            (ResTemplateField.ObsoleteState = ResTemplateField.ObsoleteState::Removed)
        then
            exit(false);

        exit(true);
    end;


    local procedure FillFieldExclusionList(var FieldExclusionList: List of [Integer])
    var
        ResTempl: Record "Resource Template";
    begin
        FieldExclusionList.Add(ResTempl.FieldNo("Base Unit of Measure"));
        FieldExclusionList.Add(ResTempl.FieldNo("No. Series"));
        //FieldExclusionList.Add(ResTempl.FieldNo("VAT Bus. Posting Gr. (Price)"));
        FieldExclusionList.Add(ResTempl.FieldNo("Resource Category Code"));
        //FieldExclusionList.add(ResTempl.FieldNo("Resource Group No."));

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


    local procedure SetBaseUoM(var Res: Record Resource; var ResTempl: Record "Resource Template")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetBaseUoM(Res, ResTempl, IsHandled);
        if IsHandled then
            exit;

        if ResTempl."Base Unit of Measure" <> '' then
            Res.Validate("Base Unit of Measure", ResTempl."Base Unit of Measure")
        else
            Res.Validate("Base Unit of Measure", GetUnitOfMeasureCode());
    end;


    /*
    local procedure CheckResTemplRoundingPrecision(var ResTempl: Record "Resource Template")
    var
        ModifyTemplate: Boolean;
    begin
        if ResTempl."Rounding Precision" = 0 then begin
            ResTempl."Rounding Precision" := 1;
            ModifyTemplate := true;
        end;
        if (ResTempl.Type = ResTempl.Type::Service) and (ResTempl.Reserve <> ResTempl.Reserve::Never) then begin
            ResTempl.Reserve := ResTempl.Reserve::Never;
            ModifyTemplate := true;
        end;
        if ModifyTemplate then
            ResTempl.Modify();
    end;
    */


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
    local procedure OnApplyTemplateOnBeforeResModify(var Res: Record Resource; ResTempl: Record "Resource Template"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyResTemplateOnBeforeResGet(var Res: Record Resource; ResTempl: Record "Resource Template"; UpdateExistingValues: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateResFromTemplateOnBeforeSelectResTemplate(Res: Record Resource; var ResTempl: Record "Resource Template")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertResFromTemplate(var Res: Record Resource; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnTemplatesAreNotEmpty(var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateResFromTemplate(var Res: Record Resource; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSaveAsTemplate(Res: Record Resource; var IsHandled: Boolean)
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
    local procedure OnBeforeCreateResFromTemplate(var Res: Record Resource; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateFromTemplate(var Res: Record Resource; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateMultipleFromTemplate(var Res: Record Resource; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateTemplateFromRes(Res: Record Resource; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertTemplateFromResOnBeforeResTemplInsert(var ResTempl: Record "Resource Template"; Res: Record Resource)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetUpdateExistingValuesParam(var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetBaseUoM(var Res: Record Resource; var ResTempl: Record "Resource Template"; var IsHandled: Boolean)
    begin
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Config. Template Management", 'OnBeforeInsertRecordWithKeyFields', '', false, false)]
    local procedure OnBeforeInsertRecordWithKeyFieldsHandler(var RecRef: RecordRef; ConfigTemplateHeader: Record "Config. Template Header")
    begin
        FillResKeyFromInitSeries(RecRef, ConfigTemplateHeader)
    end;


    procedure FillResKeyFromInitSeries(var RecRef: RecordRef; ConfigTemplateHeader: Record "Config. Template Header")
    var
        Res: Record Resource;
        NoSeries: Codeunit "No. Series";
        FldRef: FieldRef;
    begin
        if RecRef.Number = Database::Resource then begin
            if ConfigTemplateHeader."Instance No. Series" = '' then
                exit;

            //NoSeriesManagement.InitSeries(ConfigTemplateHeader."Instance No. Series", '', 0D, Res."No.", Res."No. Series");
            NoSeries.TestAutomatic(ConfigTemplateHeader."Instance No. Series");
            FldRef := RecRef.Field(Res.FieldNo("No."));
            FldRef.Value := Res."No.";
            FldRef := RecRef.Field(Res.FieldNo("No. Series"));
            FldRef.Value := Res."No. Series";
        end;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitResNo(var Res: Record Resource; ResTempl: Record "Resource Template"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateTemplateFromResOnBeforeResTemplGet(Res: Record Resource; ResTempl: Record "Resource Template")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateResFromTemplate(var Res: Record Resource; ResTempl: Record "Resource Template");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyTemplateOnBeforeValidateFields(var ResRecRef: RecordRef; var ResTemplRecRef: RecordRef; FieldExclusionList: List of [Integer]; var FieldValidationList: List of [Integer])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSelectResTemplate(ResTempl: Record "Resource Template"; var IsHandled: Boolean; var Result: Boolean)
    begin
    end;
}
