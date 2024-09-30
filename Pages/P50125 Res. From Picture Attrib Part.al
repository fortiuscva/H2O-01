page 50125 "Res. From Picture Attrib Part"
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
            repeater(AttributesRepeater)
            {
                ShowCaption = false;
                field(AttributeNameField; Rec."Attribute Name")
                {
                    ApplicationArea = All;
                    Caption = 'Attribute';
                    ToolTip = 'Specifies the resource attribute.';
                    TableRelation = "Resource Attribute".Name WHERE(Blocked = CONST(false));

                    trigger OnValidate()
                    var
                        ResAttributeValue: Record "Resource Attribute Value";
                        ResAttribute: Record "Resource Attribute";
                    begin
                        if xRec."Attribute Name" <> '' then begin
                            xRec.FindResAttributeByName(ResAttribute);
                            ResAttribute.RemoveUnusedArbitraryValues();
                        end;

                        if not Rec.FindAttributeValue(ResAttributeValue) then
                            Rec.InsertResAttributeValue(ResAttributeValue, Rec);
                    end;
                }
                field(AttributeValueField; Rec.Value)
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    ToolTip = 'Specifies the value of the resource attribute.';
                    TableRelation = IF ("Attribute Type" = CONST(Option)) "Resource Attribute Value".Value WHERE("Attribute ID" = FIELD("Attribute ID"),
                                                                                                            Blocked = CONST(false));

                    trigger OnValidate()
                    var
                        ResAttributeValue: Record "Resource Attribute Value";
                        ResAttribute: Record "Resource Attribute";
                    begin
                        if not Rec.FindAttributeValue(ResAttributeValue) then
                            Rec.InsertResAttributeValue(ResAttributeValue, Rec);

                        if ResAttribute.Get(Rec."Attribute ID") then
                            if ResAttribute.Type <> ResAttribute.Type::Option then
                                if xRec.FindAttributeValue(ResAttributeValue) then
                                    if not ResAttributeValue.HasBeenUsed() then
                                        ResAttributeValue.Delete();
                    end;
                }
                field(UnitOfMeasureField; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the resource''s unit of measure, such as piece or hour.';
                    Editable = false;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        UserEdited := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UserEdited := true;
    end;

    var
        ResFromPicture: Codeunit "Resource From Picture";
        GlobalCategoryCode: Code[20];
        UserEdited: Boolean;
        ConfirmCategoryChangeTxt: Label 'This will change the new resource category from "%1" to "%2", and will reset the resource attributes.\\ Do you want to continue?', Comment = '%1, %2: two category names, for example "furniture" and "kitchen appliances"';

    procedure LoadAttributesFromCategory(CategoryCode: Code[20])
    var
        TempResAttributeValue: Record "Resource Attribute Value" temporary;
    begin
        if CategoryCode = GlobalCategoryCode then
            exit;

        GlobalCategoryCode := CategoryCode;

        if GlobalCategoryCode = '' then
            exit;

        if UserEdited then
            if not Confirm(StrSubstNo(ConfirmCategoryChangeTxt, GlobalCategoryCode, CategoryCode)) then
                Error('');

        Rec.DeleteAll();

        PopulateFromCategoryHierarchy(GlobalCategoryCode, TempResAttributeValue);

        Rec.PopulateResAttributeValueSelection(TempResAttributeValue, DATABASE::"Resource Category", GlobalCategoryCode);
    end;

    local procedure PopulateFromCategoryHierarchy(CategoryCode: Code[20]; var TempResAttributeValue: Record "Resource Attribute Value")
    var
        ResCategory: Record "Resource Category";
    begin
        repeat
            PopulateFromCategory(CategoryCode, TempResAttributeValue);
            if ResCategory.Get(CategoryCode) then
                CategoryCode := ResCategory."Parent Category";
        until CategoryCode = '';
    end;

    local procedure PopulateFromCategory(CategoryCode: Code[20]; var TempResAttributeValue: Record "Resource Attribute Value")
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttributeValue: Record "Resource Attribute Value";
    begin
        ResAttributeValueMapping.SetRange("Table ID", DATABASE::"Resource Category");

        ResAttributeValueMapping.SetRange("No.", CategoryCode);
        if ResAttributeValueMapping.FindSet() then
            repeat
                ResAttributeValue.Get(ResAttributeValueMapping."Resource Attribute ID", ResAttributeValueMapping."Resource Attribute Value ID");
                TempResAttributeValue.TransferFields(ResAttributeValue);
                if TempResAttributeValue.Insert() then;
            until ResAttributeValueMapping.Next() = 0;
    end;

    procedure ClearValues()
    begin
        ResFromPicture.ClearAttributeValues(Rec);
    end;

    procedure SaveValues(Res: Record Resource)
    begin
        ResFromPicture.SaveAttributeValues(Rec, Res);
    end;
}