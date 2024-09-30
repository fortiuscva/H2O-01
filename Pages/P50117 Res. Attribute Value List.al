page 50117 "Res. Attribute Value List"
{
    Caption = 'Resource Attribute Values';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Res. Attribute Value Selection";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Attribute Name"; Rec."Attribute Name")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = false;
                    Caption = 'Attribute';
                    TableRelation = "Resource Attribute".Name WHERE(Blocked = CONST(false));
                    ToolTip = 'Specifies the resource attribute.';

                    trigger OnValidate()
                    var
                        ResAttributeValue: Record "Resource Attribute Value";
                        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
                        ResAttribute: Record "Resource Attribute";
                    begin
                        OnBeforeCheckAttributeName(Rec, RelatedRecordCode);
                        if xRec."Attribute Name" <> '' then begin
                            xRec.FindResAttributeByName(ResAttribute);
                            DeleteResAttributeValueMapping(ResAttribute.ID);
                        end;

                        if not rec.FindAttributeValue(ResAttributeValue) then
                            rec.InsertResAttributeValue(ResAttributeValue, Rec);

                        if ResAttributeValue.Get(ResAttributeValue."Attribute ID", ResAttributeValue.ID) then begin
                            ResAttributeValueMapping.Reset();
                            ResAttributeValueMapping.Init();
                            ResAttributeValueMapping."Table ID" := DATABASE::Resource;
                            ResAttributeValueMapping."No." := RelatedRecordCode;
                            ResAttributeValueMapping."Resource Attribute ID" := ResAttributeValue."Attribute ID";
                            ResAttributeValueMapping."Resource Attribute Value ID" := ResAttributeValue.ID;
                            OnBeforeResAttributeValueMappingInsert(ResAttributeValueMapping, ResAttributeValue, Rec);
                            ResAttributeValueMapping.Insert();
                        end;
                    end;
                }
                field(Value; rec.Value)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Value';
                    TableRelation = IF ("Attribute Type" = CONST(Option)) "Resource Attribute Value".Value WHERE("Attribute ID" = FIELD("Attribute ID"),
                                                                                                            Blocked = CONST(false));
                    ToolTip = 'Specifies the value of the resource attribute.';

                    trigger OnValidate()
                    var
                        ResAttributeValue: Record "Resource Attribute Value";
                        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
                        ResAttribute: Record "Resource Attribute";
                    begin
                        if not rec.FindAttributeValue(ResAttributeValue) then
                            rec.InsertResAttributeValue(ResAttributeValue, Rec);

                        ResAttributeValueMapping.SetRange("Table ID", DATABASE::Resource);
                        ResAttributeValueMapping.SetRange("No.", RelatedRecordCode);
                        ResAttributeValueMapping.SetRange("Resource Attribute ID", ResAttributeValue."Attribute ID");
                        if ResAttributeValueMapping.FindFirst() then begin
                            ResAttributeValueMapping."Resource Attribute Value ID" := ResAttributeValue.ID;
                            OnBeforeResAttributeValueMappingModify(ResAttributeValueMapping, ResAttributeValue, RelatedRecordCode);
                            ResAttributeValueMapping.Modify();
                            OnAfterResAttributeValueMappingModify(ResAttributeValueMapping, Rec);
                        end;

                        ResAttribute.Get(rec."Attribute ID");
                        if ResAttribute.Type <> ResAttribute.Type::Option then
                            if rec.FindAttributeValueFromRecord(ResAttributeValue, xRec) then
                                if not ResAttributeValue.HasBeenUsed() then
                                    ResAttributeValue.Delete();
                    end;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the resource''s unit of measure, such as piece or hour.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        DeleteResAttributeValueMapping(rec."Attribute ID");
    end;

    trigger OnOpenPage()
    begin
        CurrPage.Editable(true);
    end;



    protected var
        RelatedRecordCode: Code[20];



    procedure LoadAttributes(ResNo: Code[20])
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        TempResAttributeValue: Record "Resource Attribute Value" temporary;
        ResAttributeValue: Record "Resource Attribute Value";
    begin
        RelatedRecordCode := ResNo;
        ResAttributeValueMapping.SetRange("Table ID", DATABASE::Resource);
        ResAttributeValueMapping.SetRange("No.", ResNo);
        if ResAttributeValueMapping.FindSet() then
            repeat
                ResAttributeValue.Get(ResAttributeValueMapping."Resource Attribute ID", ResAttributeValueMapping."Resource Attribute Value ID");
                TempResAttributeValue.TransferFields(ResAttributeValue);
                OnLoadAttributesOnBeforeTempResAttributeValueInsert(TempResAttributeValue, ResAttributeValueMapping, RelatedRecordCode);
                TempResAttributeValue.Insert();
            until ResAttributeValueMapping.Next() = 0;

        rec.PopulateResAttributeValueSelection(TempResAttributeValue, DATABASE::Resource, ResNo);
    end;



    local procedure DeleteResAttributeValueMapping(AttributeToDeleteID: Integer)
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttribute: Record "Resource Attribute";
    begin
        ResAttributeValueMapping.SetRange("Table ID", DATABASE::Resource);
        ResAttributeValueMapping.SetRange("No.", RelatedRecordCode);
        ResAttributeValueMapping.SetRange("Resource Attribute ID", AttributeToDeleteID);
        if ResAttributeValueMapping.FindFirst() then begin
            ResAttributeValueMapping.Delete();
            OnAfterResAttributeValueMappingDelete(AttributeToDeleteID, RelatedRecordCode, Rec);
        end;

        ResAttribute.Get(AttributeToDeleteID);
        ResAttribute.RemoveUnusedArbitraryValues();
    end;



    [IntegrationEvent(false, false)]
    local procedure OnAfterResAttributeValueMappingDelete(AttributeToDeleteID: Integer; RelatedRecordCode: Code[20]; ResAttributeValueSelection: Record "Res. Attribute Value Selection")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterResAttributeValueMappingModify(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; ResAttributeValueSelection: Record "Res. Attribute Value Selection")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeResAttributeValueMappingInsert(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; ResAttributeValue: Record "Resource Attribute Value"; ResAttributeValueSelection: Record "Res. Attribute Value Selection")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeResAttributeValueMappingModify(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; ResAttributeValue: Record "Resource Attribute Value"; RelatedRecordCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLoadAttributesOnBeforeTempResAttributeValueInsert(var TempResAttributeValue: Record "Resource Attribute Value" temporary; ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; RelatedRecordCode: Code[20]);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckAttributeName(var ResAttributeValueSelection: Record "Res. Attribute Value Selection"; RelatedRecordCode: Code[20]);
    begin
    end;
}

