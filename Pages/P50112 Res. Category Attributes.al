page 50112 "Res. Category Attributes"
{
    Caption = 'Resource Category Attributes';
    LinksAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Res. Attribute Value Selection";
    SourceTableTemporary = true;
    SourceTableView = SORTING("Inheritance Level", "Attribute Name")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Enabled = RowEditable;
                ShowCaption = false;
                field("Attribute Name"; Rec."Attribute Name")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = false;
                    Caption = 'Attribute';
                    StyleExpr = StyleTxt;
                    TableRelation = "Resource Attribute".Name WHERE(Blocked = CONST(false));
                    ToolTip = 'Specifies the Resource attribute.';

                    trigger OnValidate()
                    begin
                        PersistInheritanceData();
                    end;
                }
                field(Value; rec.Value)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Default Value';
                    StyleExpr = StyleTxt;
                    TableRelation = IF ("Attribute Type" = CONST(Option)) "Resource Attribute Value".Value WHERE("Attribute ID" = FIELD("Attribute ID"),
                                                                                                            Blocked = CONST(false));
                    ToolTip = 'Specifies the value of the Resource attribute.';

                    trigger OnValidate()
                    begin
                        PersistInheritanceData();
                        ChangeDefaultValue();
                    end;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the name of the resource''s unit of measure, such as piece or hour.';
                }
                field("Inherited-From Key Value"; Rec."Inherited-From Key Value")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inherited From';
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the parent resource category that the resource attributes are inherited from.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateProperties();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateProperties();
    end;

    trigger OnClosePage()
    begin
        TempRecentlyResAttributeValueMapping.DeleteAll();
    end;

    trigger OnDeleteRecord(): Boolean
    var
        TempResAttributeValueToDelete: Record "Resource Attribute Value" temporary;
        ResAttributeValue: Record "Resource Attribute Value";
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttributeManagement: Codeunit "Resource Attribute Management";
    begin
        if rec."Inherited-From Key Value" <> '' then
            Error(DeleteInheritedAttribErr);

        ResAttributeValueMapping.SetRange("Table ID", DATABASE::"Resource Category");
        ResAttributeValueMapping.SetRange("No.", ResCategoryCode);
        ResAttributeValueMapping.SetRange("Resource Attribute ID", rec."Attribute ID");
        ResAttributeValueMapping.FindFirst();
        if ResAttributeManagement.SearchCategoryResForAttribute(ResCategoryCode, rec."Attribute ID") then
            if Confirm(StrSubstNo(DeleteResInheritedParentCategoryAttributesQst, ResCategoryCode, ResCategoryCode)) then begin
                ResAttributeValue.SetRange("Attribute ID", rec."Attribute ID");
                ResAttributeValue.SetRange(ID, ResAttributeValueMapping."Resource Attribute Value ID");
                ResAttributeValue.FindFirst();
                TempResAttributeValueToDelete.TransferFields(ResAttributeValue);
                TempResAttributeValueToDelete.Insert();
                DeleteRecentlyResAttributeValueMapping(rec."Attribute ID");
                ResAttributeManagement.DeleteCategoryResAttributeValueMapping(TempResAttributeValueToDelete, ResCategoryCode);
            end;
        ResAttributeValueMapping.Delete();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary;
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttributeManagement: Codeunit "Resource Attribute Management";
    begin
        if ResCategoryCode <> '' then begin
            ResAttributeValueMapping."Table ID" := DATABASE::"Resource Category";
            ResAttributeValueMapping."No." := ResCategoryCode;
            ResAttributeValueMapping."Resource Attribute ID" := rec."Attribute ID";
            ResAttributeValueMapping."Resource Attribute Value ID" := rec.GetAttributeValueID(TempResAttributeValueToInsert);
            OnInsertRecordOnBeforeResAttributeValueMappingInsert(ResAttributeValueMapping, TempResAttributeValueToInsert, Rec);
            ResAttributeValueMapping.Insert();
            ResAttributeManagement.InsertCategoryResBufferedAttributeValueMapping(
              TempResAttributeValueToInsert, TempRecentlyResAttributeValueMapping, ResCategoryCode);
            InsertRecentlyAddedCategoryAttribute(ResAttributeValueMapping);
        end;
    end;

    var
        ResCategoryCode: Code[20];
        DeleteInheritedAttribErr: Label 'You cannot delete attributes that are inherited from a parent Resource category.';
        RowEditable: Boolean;
        StyleTxt: Text;
        ChangingDefaultValueMsg: Label 'The new default value will not apply to Resources that use the current Resource category, ''''%1''''. It will only apply to new resources.', Comment = '%1 - Resource category code';
        DeleteResInheritedParentCategoryAttributesQst: Label 'One or more resources belong to resource category ''''%1''''.\\Do you want to delete the inherited Resource attributes for the resources in question?', Comment = '%1 - Resource category code,%2 - Resource category code';

    protected var
        TempRecentlyResAttributeValueMapping: Record "Res. Attribute Value Mapping" temporary;

    procedure LoadAttributes(CategoryCode: Code[20])
    var
        TempResAttributeValue: Record "Resource Attribute Value" temporary;
        ResAttributeValue: Record "Resource Attribute Value";
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResCategory: Record "Resource Category";
        CurrentCategoryCode: Code[20];
    begin
        rec.Reset();
        rec.DeleteAll();
        if CategoryCode = '' then
            exit;
        SortByInheritance();
        ResAttributeValueMapping.SetRange("Table ID", DATABASE::"Resource Category");
        SetResCategoryCode(CategoryCode);
        CurrentCategoryCode := CategoryCode;
        repeat
            if ResCategory.Get(CurrentCategoryCode) then begin
                ResAttributeValueMapping.SetRange("No.", CurrentCategoryCode);
                if ResAttributeValueMapping.FindSet() then
                    repeat
                        if ResAttributeValue.Get(
                             ResAttributeValueMapping."Resource Attribute ID", ResAttributeValueMapping."Resource Attribute Value ID")
                        then begin
                            TempResAttributeValue.TransferFields(ResAttributeValue);

                            OnLoadAttributesOnBeforeTempResAttributeValueInsert(ResAttributeValueMapping, TempResAttributeValue);
                            if TempResAttributeValue.Insert() then
                                if not AttributeExists(TempResAttributeValue."Attribute ID") then begin
                                    if CurrentCategoryCode = ResCategoryCode then
                                        rec.InsertRecord(TempResAttributeValue, DATABASE::"Resource Category", '')
                                    else
                                        rec.InsertRecord(TempResAttributeValue, DATABASE::"Resource Category", CurrentCategoryCode);
                                    rec."Inheritance Level" := ResCategory.Indentation;
                                    rec.Modify();
                                end;
                        end
                    until ResAttributeValueMapping.Next() = 0;
                CurrentCategoryCode := ResCategory."Parent Category";
            end else
                CurrentCategoryCode := '';
        until CurrentCategoryCode = '';
        rec.Reset();
        CurrPage.Update(false);
        SortByInheritance();
    end;

    procedure SaveAttributes(CategoryCode: Code[20])
    var
        TempNewResAttributeValue: Record "Resource Attribute Value" temporary;
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttribute: Record "Resource Attribute";
        TempNewCategResAttributeValue: Record "Resource Attribute Value" temporary;
        TempOldCategResAttributeValue: Record "Resource Attribute Value" temporary;
        ResAttributeManagement: Codeunit "Resource Attribute Management";
    begin
        if CategoryCode = '' then
            exit;
        TempOldCategResAttributeValue.LoadCategoryAttributesFactBoxData(CategoryCode);

        rec.SetRange("Inherited-From Table ID", DATABASE::"Resource Category");
        rec.SetRange("Inherited-From Key Value", '');
        rec.PopulateResAttributeValue(TempNewResAttributeValue);
        ResAttributeValueMapping.SetRange("Table ID", DATABASE::"Resource Category");
        ResAttributeValueMapping.SetRange("No.", CategoryCode);
        ResAttributeValueMapping.DeleteAll();

        if TempNewResAttributeValue.FindSet() then
            repeat
                ResAttributeValueMapping."Table ID" := DATABASE::"Resource Category";
                ResAttributeValueMapping."No." := CategoryCode;
                ResAttributeValueMapping."Resource Attribute ID" := TempNewResAttributeValue."Attribute ID";
                ResAttributeValueMapping."Resource Attribute Value ID" := TempNewResAttributeValue.ID;
                OnSaveAttributesOnBeforeResAttributeValueMappingInsert(ResAttributeValueMapping, TempNewResAttributeValue);
                ResAttributeValueMapping.Insert();
                ResAttribute.Get(ResAttributeValueMapping."Resource Attribute ID");
                ResAttribute.RemoveUnusedArbitraryValues();
            until TempNewResAttributeValue.Next() = 0;

        TempNewCategResAttributeValue.LoadCategoryAttributesFactBoxData(CategoryCode);
        ResAttributeManagement.UpdateCategoryResAttributeValueMapping(
          TempNewCategResAttributeValue, TempOldCategResAttributeValue, ResCategoryCode, ResCategoryCode);
    end;

    local procedure PersistInheritanceData()
    begin
        rec."Inherited-From Table ID" := DATABASE::"Resource Category";
        CurrPage.SaveRecord();
    end;

    procedure SetResCategoryCode(CategoryCode: Code[20])
    begin
        if ResCategoryCode <> CategoryCode then begin
            ResCategoryCode := CategoryCode;
            TempRecentlyResAttributeValueMapping.DeleteAll();
        end;
    end;

    procedure SortByInheritance()
    begin
        rec.SetCurrentKey("Inheritance Level", "Attribute Name");
    end;

    local procedure UpdateProperties()
    begin
        RowEditable := rec."Inherited-From Key Value" = '';
        if RowEditable then
            StyleTxt := 'Standard'
        else
            StyleTxt := 'Strong';
    end;

    local procedure AttributeExists(AttributeID: Integer) AttribExist: Boolean
    begin
        rec.SetRange("Attribute ID", AttributeID);
        AttribExist := not rec.IsEmpty();
        rec.Reset();
    end;

    local procedure ChangeDefaultValue()
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary;
        ResAttributeManagement: Codeunit "Resource Attribute Management";
    begin
        ResAttributeValueMapping.SetRange("Table ID", DATABASE::"Resource Category");
        ResAttributeValueMapping.SetRange("No.", ResCategoryCode);
        ResAttributeValueMapping.SetRange("Resource Attribute ID", rec."Attribute ID");
        if ResAttributeValueMapping.FindFirst() then begin
            ResAttributeValueMapping."Resource Attribute Value ID" := rec.GetAttributeValueID(TempResAttributeValueToInsert);
            ResAttributeValueMapping.Modify();
        end;

        if IsRecentlyAddedCategoryAttribute(rec."Attribute ID") then
            UpdateRecentlyResAttributeValueMapping(TempResAttributeValueToInsert)
        else
            if ResAttributeManagement.SearchCategoryResForAttribute(ResCategoryCode, rec."Attribute ID") then
                Message(StrSubstNo(ChangingDefaultValueMsg, ResCategoryCode));
    end;

    local procedure InsertRecentlyAddedCategoryAttribute(ResAttributeValueMapping: Record "Res. Attribute Value Mapping")
    begin
        TempRecentlyResAttributeValueMapping.TransferFields(ResAttributeValueMapping);
        if TempRecentlyResAttributeValueMapping.Insert() then;
    end;

    local procedure IsRecentlyAddedCategoryAttribute(AttributeID: Integer): Boolean
    begin
        TempRecentlyResAttributeValueMapping.SetRange("Resource Attribute ID", AttributeID);
        exit(not TempRecentlyResAttributeValueMapping.IsEmpty)
    end;

    local procedure UpdateRecentlyResAttributeValueMapping(var TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary)
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
    begin
        TempRecentlyResAttributeValueMapping.SetRange("Resource Attribute ID", TempResAttributeValueToInsert."Attribute ID");
        if TempRecentlyResAttributeValueMapping.FindSet() then
            repeat
                ResAttributeValueMapping.SetRange("Table ID", TempRecentlyResAttributeValueMapping."Table ID");
                ResAttributeValueMapping.SetRange("No.", TempRecentlyResAttributeValueMapping."No.");
                ResAttributeValueMapping.SetRange("Resource Attribute ID", TempRecentlyResAttributeValueMapping."Resource Attribute ID");
                ResAttributeValueMapping.FindFirst();
                ResAttributeValueMapping.Validate("Resource Attribute Value ID", TempResAttributeValueToInsert.ID);
                ResAttributeValueMapping.Modify();
            until TempRecentlyResAttributeValueMapping.Next() = 0;
    end;

    local procedure DeleteRecentlyResAttributeValueMapping(AttributeID: Integer)
    begin
        TempRecentlyResAttributeValueMapping.SetRange("Resource Attribute ID", AttributeID);
        TempRecentlyResAttributeValueMapping.DeleteAll();
    end;

    procedure GetResCategoryCode(): Code[20];
    begin
        Exit(ResCategoryCode);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertRecordOnBeforeResAttributeValueMappingInsert(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; var ResAttributeValue: Record "Resource Attribute Value"; ResAttributeValueSelection: Record "Res. Attribute Value Selection")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLoadAttributesOnBeforeTempResAttributeValueInsert(ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; var TempResAttributeValue: Record "Resource Attribute Value" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSaveAttributesOnBeforeResAttributeValueMappingInsert(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; ResAttributeValue: Record "Resource Attribute Value")
    begin
    end;
}

