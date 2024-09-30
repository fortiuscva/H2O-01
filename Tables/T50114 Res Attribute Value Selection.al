table 50114 "Res. Attribute Value Selection"
{
    Caption = 'Resource Attribute Value Selection';
    Description = 'This table is used when selecting attributes for resources or categories. It should only be used as temporary.';

    fields
    {
        field(1; "Attribute Name"; Text[250])
        {
            Caption = 'Attribute Name';
            NotBlank = true;

            trigger OnValidate()
            var
                ResAttribute: Record "Resource Attribute";
            begin
                FindResAttributeCaseInsensitive(ResAttribute);
                CheckForDuplicate();
                CheckIfBlocked(ResAttribute);
                AdjustAttributeName(ResAttribute);
                ValidateChangedAttribute(ResAttribute);
            end;
        }
        field(2; Value; Text[250])
        {
            Caption = 'Value';

            trigger OnValidate()
            var
                ResAttributeValue: Record "Resource Attribute Value";
                ResAttribute: Record "Resource Attribute";
                DecimalValue: Decimal;
                IntegerValue: Integer;
                DateValue: Date;
            begin
                if Value = '' then
                    exit;

                DateValue := 0D;
                DecimalValue := 0;
                IntegerValue := 0;

                ResAttribute.Get("Attribute ID");
                if FindResAttributeValueCaseSensitive(ResAttributeValue) then
                    CheckIfValueBlocked(ResAttributeValue);

                case "Attribute Type" of
                    "Attribute Type"::Option:
                        begin
                            if ResAttributeValue.Value = '' then begin
                                if not FindResAttributeValueCaseInsensitive(ResAttributeValue) then
                                    Error(AttributeValueDoesntExistErr, Value);
                                CheckIfValueBlocked(ResAttributeValue);
                            end;
                            AdjustAttributeValue(ResAttributeValue);
                        end;
                    "Attribute Type"::Decimal:
                        ValidateType(DecimalValue, Value, ResAttribute);
                    "Attribute Type"::Integer:
                        ValidateType(IntegerValue, Value, ResAttribute);
                    "Attribute Type"::Date:
                        ValidateType(DateValue, Value, ResAttribute);
                end;
            end;
        }
        field(3; "Attribute ID"; Integer)
        {
            Caption = 'Attribute ID';
        }
        field(4; "Unit of Measure"; Text[30])
        {
            Caption = 'Unit of Measure';
            Editable = false;
        }
        field(6; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(7; "Attribute Type"; Option)
        {
            Caption = 'Attribute Type';
            OptionCaption = 'Option,Text,Integer,Decimal,Date';
            OptionMembers = Option,Text,"Integer",Decimal,Date;
        }
        field(8; "Inherited-From Table ID"; Integer)
        {
            Caption = 'Inherited-From Table ID';
        }
        field(9; "Inherited-From Key Value"; Code[20])
        {
            Caption = 'Inherited-From Key Value';
        }
        field(10; "Inheritance Level"; Integer)
        {
            Caption = 'Inheritance Level';
        }
    }

    keys
    {
        key(Key1; "Attribute Name")
        {
            Clustered = true;
        }
        key(Key2; "Inheritance Level", "Attribute Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Attribute ID")
        {
        }
        fieldgroup(Brick; "Attribute Name", Value, "Unit of Measure")
        {
        }
    }

    var
        AttributeDoesntExistErr: Label 'The resource attribute ''%1'' doesn''t exist.', Comment = '%1 - arbitrary name';
        AttributeBlockedErr: Label 'The resource attribute ''%1'' is blocked.', Comment = '%1 - arbitrary name';
        AttributeValueBlockedErr: Label 'The resource attribute value ''%1'' is blocked.', Comment = '%1 - arbitrary name';
        AttributeValueDoesntExistErr: Label 'The resource attribute value ''%1'' doesn''t exist.', Comment = '%1 - arbitrary name';
        AttributeValueAlreadySpecifiedErr: Label 'You have already specified a value for resource attribute ''%1''.', Comment = '%1 - attribute name';
        AttributeValueTypeMismatchErr: Label 'The value ''%1'' does not match the resource attribute of type %2.', Comment = ' %1 is arbitrary string, %2 is type name';

    procedure PopulateResAttributeValueSelection(var TempResAttributeValue: Record "Resource Attribute Value" temporary)
    begin
        PopulateResAttributeValueSelection(TempResAttributeValue, 0, '')
    end;



    procedure PopulateResAttributeValueSelection(var TempResAttributeValue: Record "Resource Attribute Value" temporary; DefinedOnTableID: Integer; DefinedOnKeyValue: Code[20])
    begin
        if TempResAttributeValue.FindSet() then
            repeat
                InsertRecord(TempResAttributeValue, DefinedOnTableID, DefinedOnKeyValue);
            until TempResAttributeValue.Next() = 0;
    end;



    procedure PopulateResAttributeValue(var TempNewResAttributeValue: Record "Resource Attribute Value" temporary)
    var
        ResAttributeValue: Record "Resource Attribute Value";
        ValDecimal: Decimal;
        ValDate: Date;
    begin
        if FindSet() then
            repeat
                Clear(TempNewResAttributeValue);
                TempNewResAttributeValue.Init();
                TempNewResAttributeValue."Attribute ID" := "Attribute ID";
                TempNewResAttributeValue.Blocked := Blocked;
                ResAttributeValue.Reset();
                ResAttributeValue.SetRange("Attribute ID", "Attribute ID");
                case "Attribute Type" of
                    "Attribute Type"::Option,
                    "Attribute Type"::Text,
                    "Attribute Type"::Integer:
                        begin
                            TempNewResAttributeValue.Value := Value;
                            ResAttributeValue.SetRange(Value, Value);
                        end;
                    "Attribute Type"::Decimal:
                        begin
                            if Value <> '' then begin
                                Evaluate(ValDecimal, Value);
                                ResAttributeValue.SetRange(Value, Format(ValDecimal, 0, 9));
                                if ResAttributeValue.IsEmpty() then begin
                                    ResAttributeValue.SetRange(Value, Format(ValDecimal));
                                    if ResAttributeValue.IsEmpty() then
                                        ResAttributeValue.SetRange(Value, Value);
                                end;
                            end else
                                ResAttributeValue.SetRange(Value, Value);
                            TempNewResAttributeValue.Value := Format(ValDecimal);
                        end;
                    "Attribute Type"::Date:
                        begin
                            if Value <> '' then begin
                                Evaluate(ValDate, Value);
                                ResAttributeValue.SetRange(Value, Format(ValDate));
                                if ResAttributeValue.IsEmpty() then
                                    ResAttributeValue.SetRange(Value, Value);
                            end;
                            TempNewResAttributeValue.Value := Format(ValDate);
                        end;
                end;
                if not FindResAttributeValueByValueFilterIncludingTranslated(ResAttributeValue) then
                    InsertResAttributeValue(ResAttributeValue, Rec);
                TempNewResAttributeValue.ID := ResAttributeValue.ID;

                OnPopulateResAttributeValueOnBeforeInsert(Rec, TempNewResAttributeValue);
                TempNewResAttributeValue.Insert();
            until Next() = 0;
    end;



    local procedure FindResAttributeValueByValueFilterIncludingTranslated(var ResAttributeValue: Record "Resource Attribute Value"): Boolean
    var
        ResAttrValueTranslation: Record "Res. Attr. Value Translation";
    begin
        if ResAttributeValue.FindFirst() then
            exit(true);

        ResAttributeValue.CopyFilter("Attribute ID", ResAttrValueTranslation."Attribute ID");
        ResAttributeValue.CopyFilter(Value, ResAttrValueTranslation.Name);
        ResAttrValueTranslation.SetRange("Language Code", GetGlobalLanguageCode());

        if ResAttrValueTranslation.FindFirst() then begin
            ResAttributeValue.ID := ResAttrValueTranslation.ID;
            exit(true);
        end;

        exit(false);
    end;



    local procedure GetGlobalLanguageCode(): Text
    var
        WindowsLanguage: Record "Windows Language";
    begin
        WindowsLanguage.Get(GlobalLanguage());
        exit(WindowsLanguage."Abbreviated Name");
    end;



    procedure InsertResAttributeValue(var ResAttributeValue: Record "Resource Attribute Value"; TempResAttributeValueSelection: Record "Res. Attribute Value Selection" temporary)
    var
        ValDecimal: Decimal;
        ValDate: Date;
    begin
        Clear(ResAttributeValue);
        ResAttributeValue."Attribute ID" := TempResAttributeValueSelection."Attribute ID";
        ResAttributeValue.Blocked := TempResAttributeValueSelection.Blocked;
        case TempResAttributeValueSelection."Attribute Type" of
            TempResAttributeValueSelection."Attribute Type"::Option,
          TempResAttributeValueSelection."Attribute Type"::Text:
                ResAttributeValue.Value := TempResAttributeValueSelection.Value;
            TempResAttributeValueSelection."Attribute Type"::Integer:
                ResAttributeValue.Validate(Value, TempResAttributeValueSelection.Value);
            TempResAttributeValueSelection."Attribute Type"::Decimal:
                if TempResAttributeValueSelection.Value <> '' then begin
                    Evaluate(ValDecimal, TempResAttributeValueSelection.Value);
                    ResAttributeValue.Validate(Value, Format(ValDecimal));
                end;
            TempResAttributeValueSelection."Attribute Type"::Date:
                if TempResAttributeValueSelection.Value <> '' then begin
                    Evaluate(ValDate, TempResAttributeValueSelection.Value);
                    ResAttributeValue.Validate("Date Value", ValDate);
                end;
        end;
        ResAttributeValue.Insert();
    end;



    procedure InsertRecord(var TempResAttributeValue: Record "Resource Attribute Value" temporary; DefinedOnTableID: Integer; DefinedOnKeyValue: Code[20])
    var
        ResAttribute: Record "Resource Attribute";
    begin
        "Attribute ID" := TempResAttributeValue."Attribute ID";
        ResAttribute.Get(TempResAttributeValue."Attribute ID");
        "Attribute Name" := ResAttribute.Name;
        "Attribute Type" := ResAttribute.Type;
        Value := TempResAttributeValue.GetValueInCurrentLanguageWithoutUnitOfMeasure();
        Blocked := TempResAttributeValue.Blocked;
        "Unit of Measure" := ResAttribute."Unit of Measure";
        "Inherited-From Table ID" := DefinedOnTableID;
        "Inherited-From Key Value" := DefinedOnKeyValue;
        OnInsertRecordOnBeforeResAttrValueSelectionInsert(Rec, TempResAttributeValue);
        Insert();
    end;



    local procedure ValidateType(Variant: Variant; ValueToValidate: Text; ResAttribute: Record "Resource Attribute")
    var
        TypeHelper: Codeunit "Type Helper";
    //CultureInfo: DotNet CultureInfo;
    begin
        //if (ValueToValidate <> '') and not TypeHelper.Evaluate(Variant, ValueToValidate, '', CultureInfo.CurrentCulture.Name) then
        if (ValueToValidate <> '') and not TypeHelper.Evaluate(Variant, ValueToValidate, '', 'en-US') then
            Error(AttributeValueTypeMismatchErr, ValueToValidate, ResAttribute.Type);
    end;



    procedure FindResAttributeByName(var ResAttribute: Record "Resource Attribute")
    begin
        FindResAttributeCaseInsensitive(ResAttribute);
    end;



    local procedure FindResAttributeCaseInsensitive(var ResAttribute: Record "Resource Attribute")
    var
        AttributeName: Text[250];
    begin
        OnBeforeFindResAttributeCaseInsensitive(ResAttribute, Rec);

        ResAttribute.SetRange(Name, "Attribute Name");
        if ResAttribute.FindFirst() then
            exit;

        AttributeName := LowerCase("Attribute Name");
        ResAttribute.SetRange(Name);
        if ResAttribute.FindSet() then
            repeat
                if LowerCase(ResAttribute.Name) = AttributeName then
                    exit;
            until ResAttribute.Next() = 0;

        Error(AttributeDoesntExistErr, "Attribute Name");
    end;



    local procedure FindResAttributeValueCaseSensitive(var ResAttributeValue: Record "Resource Attribute Value"): Boolean
    begin
        ResAttributeValue.SetRange("Attribute ID", "Attribute ID");
        ResAttributeValue.SetRange(Value, Value);
        exit(ResAttributeValue.FindFirst());
    end;



    local procedure FindResAttributeValueCaseInsensitive(var ResAttributeValue: Record "Resource Attribute Value"): Boolean
    var
        AttributeValue: Text[250];
    begin
        ResAttributeValue.SetRange("Attribute ID", "Attribute ID");
        ResAttributeValue.SetRange(Value);
        if ResAttributeValue.FindSet() then begin
            AttributeValue := LowerCase(Value);
            repeat
                if LowerCase(ResAttributeValue.Value) = AttributeValue then
                    exit(true);
            until ResAttributeValue.Next() = 0;
        end;
        exit(false);
    end;



    local procedure CheckForDuplicate()
    var
        TempResAttributeValueSelection: Record "Res. Attribute Value Selection" temporary;
        AttributeName: Text[250];
    begin
        if IsEmpty() then
            exit;
        AttributeName := LowerCase("Attribute Name");
        TempResAttributeValueSelection.Copy(Rec, true);
        if TempResAttributeValueSelection.FindSet() then
            repeat
                if TempResAttributeValueSelection."Attribute ID" <> "Attribute ID" then
                    if LowerCase(TempResAttributeValueSelection."Attribute Name") = AttributeName then
                        Error(AttributeValueAlreadySpecifiedErr, "Attribute Name");
            until TempResAttributeValueSelection.Next() = 0;
    end;



    local procedure CheckIfBlocked(var ResAttribute: Record "Resource Attribute")
    begin
        if ResAttribute.Blocked then
            Error(AttributeBlockedErr, ResAttribute.Name);
    end;

    local procedure CheckIfValueBlocked(ResAttributeValue: Record "Resource Attribute Value")
    begin
        if ResAttributeValue.Blocked then
            Error(AttributeValueBlockedErr, ResAttributeValue.Value);
    end;



    local procedure AdjustAttributeName(var ResAttribute: Record "Resource Attribute")
    begin
        if "Attribute Name" <> ResAttribute.Name then
            "Attribute Name" := ResAttribute.Name;
    end;



    local procedure AdjustAttributeValue(var ResAttributeValue: Record "Resource Attribute Value")
    begin
        if Value <> ResAttributeValue.Value then
            Value := ResAttributeValue.Value;
    end;



    local procedure ValidateChangedAttribute(var ResAttribute: Record "Resource Attribute")
    begin
        if "Attribute ID" <> ResAttribute.ID then begin
            Validate("Attribute ID", ResAttribute.ID);
            Validate("Attribute Type", ResAttribute.Type);
            Validate("Unit of Measure", ResAttribute."Unit of Measure");
            OnValidateChangedAttributeOnBeforeValidateValue(ResAttribute, Rec);
            Validate(Value, '');
        end;
    end;



    procedure FindAttributeValue(var ResAttributeValue: Record "Resource Attribute Value"): Boolean
    begin
        exit(FindAttributeValueFromRecord(ResAttributeValue, Rec));
    end;



    procedure FindAttributeValueFromRecord(var ResAttributeValue: Record "Resource Attribute Value"; ResAttributeValueSelection: Record "Res. Attribute Value Selection"): Boolean
    var
        ValDecimal: Decimal;
        ValDate: Date;
    begin
        ResAttributeValue.Reset();
        ResAttributeValue.SetRange("Attribute ID", ResAttributeValueSelection."Attribute ID");
        if IsNotBlankDecimal(ResAttributeValueSelection.Value) then begin
            Evaluate(ValDecimal, ResAttributeValueSelection.Value);
            ResAttributeValue.SetRange("Numeric Value", ValDecimal);
        end else
            if IsNotBlankDate() then begin
                Evaluate(ValDate, ResAttributeValueSelection.Value);
                ResAttributeValue.SetRange("Date Value", ValDate);
            end else
                ResAttributeValue.SetRange(Value, ResAttributeValueSelection.Value);
        exit(ResAttributeValue.FindFirst());
    end;



    procedure GetAttributeValueID(var TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary): Integer
    var
        ResAttributeValue: Record "Resource Attribute Value";
        ResAttribute: Record "Resource Attribute";
        ValDecimal: Decimal;
        ValDate: Date;
    begin
        if not FindAttributeValue(ResAttributeValue) then begin
            ResAttributeValue."Attribute ID" := "Attribute ID";
            ResAttribute.Get("Attribute ID");
            if Value <> '' then
                case ResAttribute.Type of
                    ResAttribute.Type::Decimal:
                        begin
                            Evaluate(ValDecimal, Value);
                            ResAttributeValue.Validate(Value, Format(ValDecimal));
                        end;
                    ResAttribute.Type::Date:
                        begin
                            Evaluate(ValDate, Value);
                            ResAttributeValue.Validate(Value, Format(ValDate));
                        end;
                    else
                        ResAttributeValue.Value := Value;
                end;
            ResAttributeValue.Insert();
        end;
        TempResAttributeValueToInsert.TransferFields(ResAttributeValue);
        TempResAttributeValueToInsert.Insert();
        exit(ResAttributeValue.ID);
    end;



    procedure IsNotBlankDecimal(TextValue: Text[250]) Result: Boolean
    var
        ResAttribute: Record "Resource Attribute";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeIsNotBlankDecimal(Rec, TextValue, Result, IsHandled);
        if IsHandled then
            exit(Result);

        if TextValue = '' then
            exit(false);
        ResAttribute.Get("Attribute ID");
        exit(ResAttribute.Type = ResAttribute.Type::Decimal);
    end;



    procedure IsNotBlankDate(): Boolean
    var
        ResAttribute: Record "Resource Attribute";
    begin
        if Value = '' then
            exit(false);
        ResAttribute.Get("Attribute ID");
        exit(ResAttribute.Type = ResAttribute.Type::Date);
    end;



    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindResAttributeCaseInsensitive(var ResAttribute: Record "Resource Attribute"; var ResAttributeValueSelection: Record "Res. Attribute Value Selection")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeIsNotBlankDecimal(var ResAttributeValueSelection: Record "Res. Attribute Value Selection"; TextValue: Text[250]; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertRecordOnBeforeResAttrValueSelectionInsert(var ResAttributeValueSelection: Record "Res. Attribute Value Selection"; TempResAttributeValue: Record "Resource Attribute Value" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPopulateResAttributeValueOnBeforeInsert(ResAttributeValueSelection: Record "Res. Attribute Value Selection"; var TempResAttributeValue: Record "Resource Attribute Value" temporary);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateChangedAttributeOnBeforeValidateValue(ResAttribute: Record "Resource Attribute"; var ResAttributeValueSelection: Record "Res. Attribute Value Selection")
    begin
    end;
}

