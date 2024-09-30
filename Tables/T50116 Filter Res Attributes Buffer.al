table 50116 "Filter Res. Attributes Buffer"
{
    Caption = 'Filter Resource Attributes Buffer';
    ReplicateData = false;
    Description = 'This table is used by the Filter Resource By Attribute feature. It should only be used as temporary.';

    fields
    {
        field(1; Attribute; Text[250])
        {
            Caption = 'Attribute';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                ResAttribute: Record "Resource Attribute";
            begin
                if not FindResAttributeCaseInsensitive(ResAttribute) then
                    Error(AttributeDoesntExistErr, Attribute);
                CheckForDuplicate();
                AdjustAttributeName(ResAttribute);
            end;
        }
        field(2; Value; Text[250])
        {
            Caption = 'Value';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                ResAttributeValue: Record "Resource Attribute Value";
                ResAttribute: Record "Resource Attribute";
            begin
                if Value <> '' then
                    if FindResAttributeCaseSensitive(ResAttribute) then
                        if ResAttribute.Type = ResAttribute.Type::Option then
                            if FindResAttributeValueCaseInsensitive(ResAttribute, ResAttributeValue) then
                                AdjustAttributeValue(ResAttributeValue);
            end;
        }
        field(3; ID; Guid)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
        }
    }


    keys
    {
        key(Key1; Attribute)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }



    trigger OnInsert()
    begin
        if IsNullGuid(ID) then
            ID := CreateGuid();
    end;



    var
        AttributeDoesntExistErr: Label 'The resource attribute ''%1'' doesn''t exist.', Comment = '%1 - arbitrary name';
        AttributeValueAlreadySpecifiedErr: Label 'You have already specified a value for resource attribute ''%1''.', Comment = '%1 - attribute name';



    procedure ValueAssistEdit()
    var
        ResAttribute: Record "Resource Attribute";
        FilterResAssistEdit: Page "Filter Resources - AssistEdit";
    begin
        if FindResAttributeCaseSensitive(ResAttribute) then
            if ResAttribute.Type = ResAttribute.Type::Option then begin
                FilterResAssistEdit.SetRecord(ResAttribute);
                Value := CopyStr(FilterResAssistEdit.LookupOptionValue(Value), 1, MaxStrLen(Value));
                exit;
            end;

        FilterResAssistEdit.SetTableView(ResAttribute);
        FilterResAssistEdit.LookupMode(true);
        if FilterResAssistEdit.RunModal() = ACTION::LookupOK then
            Value := CopyStr(FilterResAssistEdit.GenerateFilter(), 1, MaxStrLen(Value));
    end;



    local procedure FindResAttributeCaseSensitive(var ResAttribute: Record "Resource Attribute"): Boolean
    begin
        ResAttribute.SetRange(Name, Attribute);
        exit(ResAttribute.FindFirst());
    end;



    local procedure FindResAttributeCaseInsensitive(var ResAttribute: Record "Resource Attribute"): Boolean
    var
        AttributeName: Text[250];
    begin
        if FindResAttributeCaseSensitive(ResAttribute) then
            exit(true);

        AttributeName := LowerCase(Attribute);
        ResAttribute.SetRange(Name);
        if ResAttribute.FindSet() then
            repeat
                if LowerCase(ResAttribute.Name) = AttributeName then
                    exit(true);
            until ResAttribute.Next() = 0;

        exit(false);
    end;



    local procedure FindResAttributeValueCaseInsensitive(var ResAttribute: Record "Resource Attribute"; var ResAttributeValue: Record "Resource Attribute Value"): Boolean
    var
        AttributeValue: Text[250];
    begin
        ResAttributeValue.SetRange("Attribute ID", ResAttribute.ID);
        ResAttributeValue.SetRange(Value, Value);
        if ResAttributeValue.FindFirst() then
            exit(true);

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
        TempFilterResAttributesBuffer: Record "Filter Res. Attributes Buffer" temporary;
        AttributeName: Text[250];
    begin
        if IsEmpty() then
            exit;
        AttributeName := LowerCase(Attribute);
        TempFilterResAttributesBuffer.Copy(Rec, true);
        if TempFilterResAttributesBuffer.FindSet() then
            repeat
                if TempFilterResAttributesBuffer.ID <> ID then
                    if LowerCase(TempFilterResAttributesBuffer.Attribute) = AttributeName then
                        Error(AttributeValueAlreadySpecifiedErr, Attribute);
            until TempFilterResAttributesBuffer.Next() = 0;
    end;



    local procedure AdjustAttributeName(var ResAttribute: Record "Resource Attribute")
    begin
        if Attribute <> ResAttribute.Name then
            Attribute := ResAttribute.Name;
    end;



    local procedure AdjustAttributeValue(var ResAttributeValue: Record "Resource Attribute Value")
    begin
        if Value <> ResAttributeValue.Value then
            Value := ResAttributeValue.Value;
    end;
}