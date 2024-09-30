table 50115 "Res. Attribute Value Mapping"
{
    Caption = 'Res. Attribute Value Mapping';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Description = 'The table of the record to which the attribute applies (for example Database::Resource or Database::"Resource Category").';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            Description = 'The key of the record to which the attribute applies (the record type is specified by "Table ID").';
        }
        field(3; "Resource Attribute ID"; Integer)
        {
            Caption = 'Resource Attribute ID';
            TableRelation = "Resource Attribute";
        }
        field(4; "Resource Attribute Value ID"; Integer)
        {
            Caption = 'Resource Attribute Value ID';
            TableRelation = "Resource Attribute Value".ID;
        }
    }



    keys
    {
        key(Key1; "Table ID", "No.", "Resource Attribute ID")
        {
            Clustered = true;
        }
        key(Key2; "Resource Attribute ID", "Resource Attribute Value ID")
        {
        }
    }

    fieldgroups
    {
    }



    trigger OnDelete()
    var
        ResAttribute: Record "Resource Attribute";
        ResAttributeValue: Record "Resource Attribute Value";
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnDelete(Rec, IsHandled);
        if IsHandled then
            exit;

        ResAttribute.Get("Resource Attribute ID");
        if ResAttribute.Type = ResAttribute.Type::Option then
            exit;

        if not ResAttributeValue.Get("Resource Attribute ID", "Resource Attribute Value ID") then
            exit;

        ResAttributeValueMapping.SetRange("Resource Attribute ID", "Resource Attribute ID");
        ResAttributeValueMapping.SetRange("Resource Attribute Value ID", "Resource Attribute Value ID");
        if ResAttributeValueMapping.Count <> 1 then
            exit;

        ResAttributeValueMapping := Rec;
        if ResAttributeValueMapping.Find() then
            ResAttributeValue.Delete();
    end;



    trigger OnInsert()
    var
        ResAttributeValue: Record "Resource Attribute Value";
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.Open("Table ID");
        FieldRef := RecRef.Field(1);
        FieldRef.SetRange("No.");
        RecRef.FindFirst();

        if "Resource Attribute Value ID" <> 0 then
            ResAttributeValue.Get("Resource Attribute ID", "Resource Attribute Value ID");
    end;



    procedure RenameResAttributeValueMapping(PrevNo: Code[20]; NewNo: Code[20])
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
    begin
        SetRange("Table ID", DATABASE::Resource);
        SetRange("No.", PrevNo);
        if FindSet() then
            repeat
                ResAttributeValueMapping := Rec;
                ResAttributeValueMapping.Rename("Table ID", NewNo, "Resource Attribute ID");
            until Next() = 0;
    end;



    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; var IsHandled: Boolean)
    begin
    end;
}