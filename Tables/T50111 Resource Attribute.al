table 50111 "Resource Attribute"
{
    Caption = 'Resource Attribute';
    DataCaptionFields = Name;
    LookupPageID = "Resource Attributes";

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
            NotBlank = true;
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
            NotBlank = true;

            trigger OnValidate()
            begin
                if xRec.Name = Name then
                    exit;

                TestField(Name);
                if HasBeenUsed() then
                    if not Confirm(RenameUsedAttributeQst) then
                        Error('');
                CheckNameUniqueness(Rec, Name);
                DeleteValuesAndTranslationsConditionally(xRec, Name);
            end;
        }
        field(6; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            InitValue = Text;
            OptionCaption = 'Option,Text,Integer,Decimal,Date';
            OptionMembers = Option,Text,"Integer",Decimal,Date;

            trigger OnValidate()
            var
                ResAttributeValue: Record "Resource Attribute Value";
            begin
                if xRec.Type <> Type then begin
                    ResAttributeValue.SetRange("Attribute ID", ID);
                    if not ResAttributeValue.IsEmpty() then
                        Error(ChangingAttributeTypeErr, Name);
                end;
            end;
        }
        field(8; "Unit of Measure"; Text[30])
        {
            Caption = 'Unit of Measure';

            trigger OnValidate()
            begin
                if (xRec."Unit of Measure" <> '') and (xRec."Unit of Measure" <> "Unit of Measure") then
                    if HasBeenUsed() then
                        if not Confirm(ChangeUsedAttributeUoMQst) then
                            Error('');
            end;
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
        key(Key2; Name)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Name)
        {
        }
        fieldgroup(Brick; ID, Name)
        {
        }
    }

    trigger OnDelete()
    begin
        if HasBeenUsed() then
            if not Confirm(DeleteUsedAttributeQst) then
                Error('');
        DeleteValuesAndTranslations();
    end;

    trigger OnRename()
    var
        ResAttributeValue: Record "Resource Attribute Value";
    begin
        ResAttributeValue.SetRange("Attribute ID", xRec.ID);
        if ResAttributeValue.FindSet() then
            repeat
                ResAttributeValue.Rename(ID, ResAttributeValue.ID);
            until ResAttributeValue.Next() = 0;
    end;

    trigger OnInsert()
    begin
        TestField(Name);
    end;

    var
        ResAttributeTranslation: Record "Resource Attribute Translation";
        NameAlreadyExistsErr: Label 'The resource attribute with name ''%1'' already exists.', Comment = '%1 - arbitrary name';
        ReuseValueTranslationsQst: Label 'There are values and translations for resource attribute ''%1''.\\Do you want to reuse them after changing the resource attribute name to ''%2''?', Comment = '%1 - arbitrary name,%2 - arbitrary name';
        ChangingAttributeTypeErr: Label 'You cannot change the type of resource attribute ''%1'', because it is either in use or it has predefined values.', Comment = '%1 - arbirtrary text';
        DeleteUsedAttributeQst: Label 'This resource attribute has been assigned to at least one resource.\\Are you sure you want to delete it?';
        RenameUsedAttributeQst: Label 'This resource attribute has been assigned to at least one resource.\\Are you sure you want to rename it?';
        ChangeUsedAttributeUoMQst: Label 'This resource attribute has been assigned to at least one resource.\\Are you sure you want to change its unit of measure?';
        ChangeToOptionQst: Label 'Predefined values can be defined only for resource attributes of type Option.\\Do you want to change the type of this resource attribute to Option?';

    procedure GetTranslatedName(LanguageID: Integer): Text[250]
    var
        Language: Codeunit Language;
        LanguageCode: Code[10];
    begin
        LanguageCode := Language.GetLanguageCode(LanguageID);
        if LanguageCode <> '' then begin
            GetAttributeTranslation(LanguageCode);
            exit(ResAttributeTranslation.Name);
        end;
        exit(Name);
    end;

    procedure GetNameInCurrentLanguage(): Text[250]
    begin
        exit(GetTranslatedName(GlobalLanguage));
    end;

    local procedure GetAttributeTranslation(LanguageCode: Code[10])
    begin
        if (ResAttributeTranslation."Attribute ID" <> ID) or (ResAttributeTranslation."Language Code" <> LanguageCode) then
            if not ResAttributeTranslation.Get(ID, LanguageCode) then begin
                ResAttributeTranslation.Init();
                ResAttributeTranslation."Attribute ID" := ID;
                ResAttributeTranslation."Language Code" := LanguageCode;
                ResAttributeTranslation.Name := Name;
            end;
    end;

    procedure GetValues() Values: Text
    var
        ResAttributeValue: Record "Resource Attribute Value";
    begin
        if Type <> Type::Option then
            exit('');
        ResAttributeValue.SetRange("Attribute ID", ID);
        if ResAttributeValue.FindSet() then
            repeat
                if Values <> '' then
                    Values += ',';
                Values += ResAttributeValue.Value;
            until ResAttributeValue.Next() = 0;
    end;

    procedure HasBeenUsed() AttributeHasBeenUsed: Boolean
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
    begin
        ResAttributeValueMapping.SetRange("Resource Attribute ID", ID);
        AttributeHasBeenUsed := not ResAttributeValueMapping.IsEmpty();
        OnAfterHasBeenUsed(Rec, AttributeHasBeenUsed);
    end;

    procedure RemoveUnusedArbitraryValues()
    var
        ResAttributeValue: Record "Resource Attribute Value";
    begin
        if Type = Type::Option then
            exit;

        ResAttributeValue.SetRange("Attribute ID", ID);
        if ResAttributeValue.FindSet() then
            repeat
                if not ResAttributeValue.HasBeenUsed() then
                    ResAttributeValue.Delete();
            until ResAttributeValue.Next() = 0;
    end;

    procedure OpenResAttributeValues()
    var
        ResAttributeValue: Record "Resource Attribute Value";
    begin
        ResAttributeValue.SetRange("Attribute ID", ID);
        if (Type <> Type::Option) and ResAttributeValue.IsEmpty() then
            if Confirm(ChangeToOptionQst) then begin
                Validate(Type, Type::Option);
                Modify();
            end;

        if Type = Type::Option then
            PAGE.Run(PAGE::"Resource Attribute Values", ResAttributeValue);
    end;

    local procedure CheckNameUniqueness(ResAttribute: Record "Resource Attribute"; NameToCheck: Text[250])
    begin
        OnBeforeCheckNameUniqueness(ResAttribute, Rec);

        ResAttribute.SetRange(Name, NameToCheck);
        ResAttribute.SetFilter(ID, '<>%1', ResAttribute.ID);
        if not ResAttribute.IsEmpty() then
            Error(NameAlreadyExistsErr, NameToCheck);
    end;

    local procedure DeleteValuesAndTranslationsConditionally(ResAttribute: Record "Resource Attribute"; NameToCheck: Text[250])
    var
        ResAttributeTranslation: Record "Resource Attribute Translation";
        ResAttributeValue: Record "Resource Attribute Value";
        ValuesOrTranslationsExist: Boolean;
    begin
        if (ResAttribute.Name <> '') and (ResAttribute.Name <> NameToCheck) then begin
            ResAttributeValue.SetRange("Attribute ID", ID);
            ResAttributeTranslation.SetRange("Attribute ID", ID);
            ValuesOrTranslationsExist := not (ResAttributeValue.IsEmpty() and ResAttributeTranslation.IsEmpty);
            if ValuesOrTranslationsExist then
                if not Confirm(StrSubstNo(ReuseValueTranslationsQst, ResAttribute.Name, NameToCheck)) then
                    DeleteValuesAndTranslations();
        end;
    end;

    local procedure DeleteValuesAndTranslations()
    var
        ResAttributeValue: Record "Resource Attribute Value";
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttrValueTranslation: Record "Res. Attr. Value Translation";
    begin
        ResAttributeValueMapping.SetRange("Resource Attribute ID", ID);
        ResAttributeValueMapping.DeleteAll();

        ResAttributeValue.SetRange("Attribute ID", ID);
        ResAttributeValue.DeleteAll();

        ResAttributeTranslation.SetRange("Attribute ID", ID);
        ResAttributeTranslation.DeleteAll();

        ResAttrValueTranslation.SetRange("Attribute ID", ID);
        ResAttrValueTranslation.DeleteAll();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterHasBeenUsed(var ResAttribute: Record "Resource Attribute"; var AttributeHasBeenUsed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckNameUniqueness(var NewResAttribute: Record "Resource Attribute"; ResAttribute: Record "Resource Attribute")
    begin
    end;
}

