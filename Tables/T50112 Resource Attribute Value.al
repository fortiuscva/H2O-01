table 50112 "Resource Attribute Value"
{
    Caption = 'Resource Attribute Value';
    DataCaptionFields = Value;
    LookupPageID = "Resource Attribute Values";

    fields
    {
        field(1; "Attribute ID"; Integer)
        {
            Caption = 'Attribute ID';
            NotBlank = true;
            TableRelation = "Resource Attribute".ID WHERE(Blocked = CONST(false));
        }
        field(2; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(3; Value; Text[250])
        {
            Caption = 'Value';

            trigger OnValidate()
            var
                ResAttribute: Record "Resource Attribute";
            begin
                if xRec.Value = Value then
                    exit;

                TestField(Value);
                if HasBeenUsed() then
                    if not Confirm(RenameUsedAttributeValueQst) then
                        Error('');

                CheckValueUniqueness(Rec, Value);
                DeleteTranslationsConditionally(xRec, Value);

                ResAttribute.Get("Attribute ID");
                if IsNumeric(ResAttribute) then
                    Evaluate("Numeric Value", Value);
                if ResAttribute.Type = ResAttribute.Type::Date then
                    Evaluate("Date Value", Value);
            end;
        }
        field(4; "Numeric Value"; Decimal)
        {
            BlankZero = true;
            Caption = 'Numeric Value';

            trigger OnValidate()
            var
                ResAttribute: Record "Resource Attribute";
            begin
                if xRec."Numeric Value" = "Numeric Value" then
                    exit;

                ResAttribute.Get("Attribute ID");
                if IsNumeric(ResAttribute) then
                    Validate(Value, Format("Numeric Value", 0, 9));
            end;
        }
        field(5; "Date Value"; Date)
        {
            Caption = 'Date Value';

            trigger OnValidate()
            var
                ResAttribute: Record "Resource Attribute";
            begin
                if xRec."Date Value" = "Date Value" then
                    exit;

                ResAttribute.Get("Attribute ID");
                if ResAttribute.Type = ResAttribute.Type::Date then
                    Validate(Value, Format("Date Value"));
            end;
        }
        field(6; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(10; "Attribute Name"; Text[250])
        {
            CalcFormula = Lookup("Resource Attribute".Name WHERE(ID = FIELD("Attribute ID")));
            Caption = 'Attribute Name';
            FieldClass = FlowField;
        }
    }


    keys
    {
        key(Key1; "Attribute ID", ID)
        {
            Clustered = true;
        }
        key(Key2; Value)
        {
        }
    }


    fieldgroups
    {
        fieldgroup(DropDown; Value)
        {
        }
        fieldgroup(Brick; "Attribute Name", Value)
        {
        }
    }



    trigger OnDelete()
    var
        ResAttrValueTranslation: Record "Res. Attr. Value Translation";
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
    begin
        if HasBeenUsed() then
            if not Confirm(DeleteUsedAttributeValueQst) then
                Error('');
        ResAttributeValueMapping.SetRange("Resource Attribute ID", "Attribute ID");
        ResAttributeValueMapping.SetRange("Resource Attribute Value ID", ID);
        ResAttributeValueMapping.DeleteAll();

        ResAttrValueTranslation.SetRange("Attribute ID", "Attribute ID");
        ResAttrValueTranslation.SetRange(ID, ID);
        ResAttrValueTranslation.DeleteAll();
    end;



    var
        TransformationRule: Record "Transformation Rule";
        NameAlreadyExistsErr: Label 'The resource attribute value with value ''%1'' already exists.', Comment = '%1 - arbitrary name';
        ReuseValueTranslationsQst: Label 'There are translations for resource attribute value ''%1''.\\Do you want to reuse these translations for the new value ''%2''?', Comment = '%1 - arbitrary name,%2 - arbitrary name';
        DeleteUsedAttributeValueQst: Label 'This resource attribute value has been assigned to at least one resource.\\Are you sure you want to delete it?';
        RenameUsedAttributeValueQst: Label 'This resource attribute value has been assigned to at least one resource.\\Are you sure you want to rename it?';



    procedure LookupAttributeValue(AttributeID: Integer; var AttributeValueID: Integer)
    var
        ResAttributeValue: Record "Resource Attribute Value";
        ResAttributeValues: Page "Resource Attribute Values";
    begin
        ResAttributeValue.SetRange("Attribute ID", AttributeID);
        ResAttributeValues.LookupMode := true;
        ResAttributeValues.SetTableView(ResAttributeValue);
        if ResAttributeValue.Get(AttributeID, AttributeValueID) then
            ResAttributeValues.SetRecord(ResAttributeValue);
        if ResAttributeValues.RunModal() = ACTION::LookupOK then begin
            ResAttributeValues.GetRecord(ResAttributeValue);
            AttributeValueID := ResAttributeValue.ID;
        end;
    end;



    procedure GetAttributeNameInCurrentLanguage(): Text[250]
    var
        ResAttribute: Record "Resource Attribute";
    begin
        if ResAttribute.Get("Attribute ID") then
            exit(ResAttribute.GetNameInCurrentLanguage());
        exit('');
    end;



    procedure GetValueInCurrentLanguage() ValueTxt: Text[250]
    var
        ResAttribute: Record "Resource Attribute";
    begin
        ValueTxt := GetValueInCurrentLanguageWithoutUnitOfMeasure();

        if ResAttribute.Get("Attribute ID") then
            case ResAttribute.Type of
                ResAttribute.Type::Integer,
              ResAttribute.Type::Decimal:
                    if ValueTxt <> '' then
                        exit(AppendUnitOfMeasure(ValueTxt, ResAttribute));
            end;

        OnAfterGetValueInCurrentLanguage(Rec, ValueTxt);
    end;



    procedure GetValueInCurrentLanguageWithoutUnitOfMeasure(): Text[250]
    var
        ResAttribute: Record "Resource Attribute";
    begin
        if ResAttribute.Get("Attribute ID") then
            case ResAttribute.Type of
                ResAttribute.Type::Option:
                    exit(GetTranslatedName(GlobalLanguage));
                ResAttribute.Type::Text:
                    exit(Value);
                ResAttribute.Type::Integer:
                    if Value <> '' then
                        exit(Format(Value));
                ResAttribute.Type::Decimal:
                    if Value <> '' then
                        exit(Format("Numeric Value"));
                ResAttribute.Type::Date:
                    exit(Format("Date Value"));
                else begin
                    OnGetValueInCurrentLanguage(ResAttribute, Rec);
                    exit(Value);
                end;
            end;
        exit('');
    end;



    procedure GetTranslatedName(LanguageID: Integer): Text[250]
    var
        Language: Codeunit Language;
        LanguageCode: Code[10];
    begin
        LanguageCode := Language.GetLanguageCode(LanguageID);
        if LanguageCode <> '' then
            exit(GetTranslatedNameByLanguageCode(LanguageCode));
        exit(Value);
    end;



    procedure GetTranslatedNameByLanguageCode(LanguageCode: Code[10]): Text[250]
    var
        ResAttrValueTranslation: Record "Res. Attr. Value Translation";
    begin
        if not ResAttrValueTranslation.Get("Attribute ID", ID, LanguageCode) then
            exit(Value);
        exit(ResAttrValueTranslation.Name);
    end;



    local procedure CheckValueUniqueness(ResAttributeValue: Record "Resource Attribute Value"; NameToCheck: Text[250])
    begin
        ResAttributeValue.SetRange("Attribute ID", "Attribute ID");
        ResAttributeValue.SetFilter(ID, '<>%1', ResAttributeValue.ID);
        ResAttributeValue.SetRange(Value, NameToCheck);
        if not ResAttributeValue.IsEmpty() then
            Error(NameAlreadyExistsErr, NameToCheck);
    end;



    local procedure DeleteTranslationsConditionally(ResAttributeValue: Record "Resource Attribute Value"; NameToCheck: Text[250])
    var
        ResAttrValueTranslation: Record "Res. Attr. Value Translation";
    begin
        if (ResAttributeValue.Value <> '') and (ResAttributeValue.Value <> NameToCheck) then begin
            ResAttrValueTranslation.SetRange("Attribute ID", "Attribute ID");
            ResAttrValueTranslation.SetRange(ID, ID);
            if not ResAttrValueTranslation.IsEmpty() then
                if not Confirm(StrSubstNo(ReuseValueTranslationsQst, ResAttributeValue.Value, NameToCheck)) then
                    ResAttrValueTranslation.DeleteAll();
        end;
    end;



    local procedure AppendUnitOfMeasure(String: Text; ResAttribute: Record "Resource Attribute"): Text
    begin
        if ResAttribute."Unit of Measure" <> '' then
            exit(StrSubstNo('%1 %2', String, Format(ResAttribute."Unit of Measure")));
        exit(String);
    end;



    procedure HasBeenUsed(): Boolean
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        AttributeHasBeenUsed: Boolean;
    begin
        ResAttributeValueMapping.SetRange("Resource Attribute ID", "Attribute ID");
        ResAttributeValueMapping.SetRange("Resource Attribute Value ID", ID);
        AttributeHasBeenUsed := not ResAttributeValueMapping.IsEmpty();
        OnAfterHasBeenUsed(Rec, AttributeHasBeenUsed);
        exit(AttributeHasBeenUsed);
    end;



    procedure SetValueFilter(var ResAttribute: Record "Resource Attribute"; FilterText: Text)
    var
        IndexOfOrCondition: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetValueFilter(Rec, ResAttribute, FilterText, IsHandled);
        if IsHandled then
            exit;

        SetRange("Numeric Value");
        SetRange(Value);

        if IsNumeric(ResAttribute) then begin
            SetFilter("Numeric Value", FilterText);
            exit;
        end;

        if ResAttribute.Type = ResAttribute.Type::Text then
            if (StrPos(FilterText, '*') = 0) and (StrPos(FilterText, '''') = 0) then begin
                FilterText := StrSubstNo('@*%1*', LowerCase(FilterText));
                IndexOfOrCondition := StrPos(FilterText, '|');
                if IndexOfOrCondition > 0 then begin
                    TransformationRule.Init();
                    TransformationRule."Find Value" := '|';
                    TransformationRule."Replace Value" := '*|@*';
                    TransformationRule."Transformation Type" := TransformationRule."Transformation Type"::Replace;
                    FilterText := TransformationRule.TransformText(FilterText);
                end
            end;

        if ResAttribute.Type = ResAttribute.Type::Date then
            if FilterText <> '' then begin
                SetFilter("Date Value", FilterText);
                exit;
            end;

        SetFilter(Value, FilterText);
    end;



    local procedure IsNumeric(var ResAttribute: Record "Resource Attribute"): Boolean
    begin
        exit(ResAttribute.Type in [ResAttribute.Type::Integer, ResAttribute.Type::Decimal]);
    end;



    procedure LoadResAttributesFactBoxData(KeyValue: Code[20])
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttributeValue: Record "Resource Attribute Value";
    begin
        Reset();
        DeleteAll();
        ResAttributeValueMapping.SetRange("Table ID", DATABASE::Resource);
        ResAttributeValueMapping.SetRange("No.", KeyValue);
        if ResAttributeValueMapping.FindSet() then
            repeat
                if ResAttributeValue.Get(ResAttributeValueMapping."Resource Attribute ID", ResAttributeValueMapping."Resource Attribute Value ID") then begin
                    TransferFields(ResAttributeValue);
                    OnLoadResAttributesFactBoxDataOnBeforeInsert(ResAttributeValueMapping, Rec);
                    Insert();
                end
            until ResAttributeValueMapping.Next() = 0;
    end;



    procedure LoadCategoryAttributesFactBoxData(CategoryCode: Code[20])
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttributeValue: Record "Resource Attribute Value";
        ResCategory: Record "Resource Category";
    begin
        Reset();
        DeleteAll();
        if CategoryCode = '' then
            exit;
        ResAttributeValueMapping.SetRange("Table ID", DATABASE::"Resource Category");
        repeat
            ResAttributeValueMapping.SetRange("No.", CategoryCode);
            if ResAttributeValueMapping.FindSet() then
                repeat
                    if ResAttributeValue.Get(ResAttributeValueMapping."Resource Attribute ID", ResAttributeValueMapping."Resource Attribute Value ID") then
                        if not AttributeExists(ResAttributeValue."Attribute ID") then begin
                            TransferFields(ResAttributeValue);
                            OnLoadResAttributesFactBoxDataOnBeforeInsert(ResAttributeValueMapping, Rec);
                            Insert();
                        end;
                until ResAttributeValueMapping.Next() = 0;
            if ResCategory.Get(CategoryCode) then
                CategoryCode := ResCategory."Parent Category"
            else
                CategoryCode := '';
        until CategoryCode = '';
    end;



    local procedure AttributeExists(AttributeID: Integer) AttribExist: Boolean
    begin
        SetRange("Attribute ID", AttributeID);
        AttribExist := not IsEmpty();
        Reset();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetValueInCurrentLanguage(ResAttributeValue: Record "Resource Attribute Value"; var ValueTxt: Text[250])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterHasBeenUsed(ResAttributeValue: Record "Resource Attribute Value"; var AttributeHasBeenUsed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetValueFilter(var ResAttributeValue: Record "Resource Attribute Value"; ResAttribute: Record "Resource Attribute"; FilterText: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetValueInCurrentLanguage(ResAttribute: Record "Resource Attribute"; var ResAttributeValue: Record "Resource Attribute Value")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLoadResAttributesFactBoxDataOnBeforeInsert(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; var ResAttributeValue: Record "Resource Attribute Value")
    begin
    end;
}