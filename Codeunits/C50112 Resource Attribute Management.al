codeunit 50112 "Resource Attribute Management"
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
        DeleteAttributesInheritedFromOldCategoryQst: Label 'Do you want to delete the attributes that are inherited from resource category ''%1''?', Comment = '%1 - resource category code';
        DeleteResInheritedParentCategoryAttributesQst: Label 'One or more resources belong to resource category ''''%1'''', which is a child of resource category ''''%2''''.\\Do you want to delete the inherited resource attributes for the resources in question?', Comment = '%1 - resource category code,%2 - resource category code';



    procedure FindResByAttribute(var FilterResAttributesBuffer: Record "Filter Res. Attributes Buffer") ResFilter: Text
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttribute: Record "Resource Attribute";
        AttributeValueIDFilter: Text;
        CurrentResFilter: Text;
    begin
        if not FilterResAttributesBuffer.FindSet() then
            exit;

        ResFilter := '<>*';

        ResAttributeValueMapping.SetRange("Table ID", DATABASE::Resource);
        CurrentResFilter := '*';

        repeat
            ResAttribute.SetRange(Name, FilterResAttributesBuffer.Attribute);
            if ResAttribute.FindFirst() then begin
                ResAttributeValueMapping.SetRange("Resource Attribute ID", ResAttribute.ID);
                AttributeValueIDFilter := GetResAttributeValueFilter(FilterResAttributesBuffer, ResAttribute);
                if AttributeValueIDFilter = '' then
                    exit;

                CurrentResFilter := GetResNoFilter(ResAttributeValueMapping, CurrentResFilter, AttributeValueIDFilter);
                if CurrentResFilter = '' then
                    exit;
            end;
        until FilterResAttributesBuffer.Next() = 0;

        ResFilter := CurrentResFilter;
    end;


    procedure FindResByAttributes(var FilterResAttributesBuffer: Record "Filter Res. Attributes Buffer"; var TempFilteredRes: Record Resource temporary)
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttribute: Record "Resource Attribute";
        AttributeValueIDFilter: Text;
    begin
        if not FilterResAttributesBuffer.FindSet() then
            exit;

        ResAttributeValueMapping.SetRange("Table ID", DATABASE::Resource);

        OnFindResByAttributesOnBeforeFilterResAttributesBufferLoop(FilterResAttributesBuffer, TempFilteredRes, ResAttributeValueMapping);
        repeat
            ResAttribute.SetRange(Name, FilterResAttributesBuffer.Attribute);
            if ResAttribute.FindFirst() then begin
                ResAttributeValueMapping.SetRange("Resource Attribute ID", ResAttribute.ID);
                AttributeValueIDFilter := GetResAttributeValueFilter(FilterResAttributesBuffer, ResAttribute);
                if AttributeValueIDFilter = '' then begin
                    TempFilteredRes.DeleteAll();
                    exit;
                end;

                GetFilteredResources(ResAttributeValueMapping, TempFilteredRes, AttributeValueIDFilter);
                if TempFilteredRes.IsEmpty() then
                    exit;
            end;
        until FilterResAttributesBuffer.Next() = 0;
    end;


    local procedure GetResAttributeValueFilter(var FilterResAttributesBuffer: Record "Filter Res. Attributes Buffer"; var ResAttribute: Record "Resource Attribute") AttributeFilter: Text
    var
        ResAttributeValue: Record "Resource Attribute Value";
    begin
        ResAttributeValue.SetRange("Attribute ID", ResAttribute.ID);
        ResAttributeValue.SetValueFilter(ResAttribute, FilterResAttributesBuffer.Value);

        if not ResAttributeValue.FindSet() then
            exit;

        repeat
            AttributeFilter += StrSubstNo('%1|', ResAttributeValue.ID);
        until ResAttributeValue.Next() = 0;

        exit(CopyStr(AttributeFilter, 1, StrLen(AttributeFilter) - 1));
    end;


    local procedure GetResNoFilter(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; PreviousResNoFilter: Text; AttributeValueIDFilter: Text) ResNoFilter: Text
    begin
        ResAttributeValueMapping.SetFilter("No.", PreviousResNoFilter);
        ResAttributeValueMapping.SetFilter("Resource Attribute Value ID", AttributeValueIDFilter);

        if not ResAttributeValueMapping.FindSet() then
            exit;

        repeat
            ResNoFilter += StrSubstNo('%1|', ResAttributeValueMapping."No.");
        until ResAttributeValueMapping.Next() = 0;

        exit(CopyStr(ResNoFilter, 1, StrLen(ResNoFilter) - 1));
    end;


    local procedure GetFilteredResources(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; var TempFilteredRes: Record Resource temporary; AttributeValueIDFilter: Text)
    var
        Res: Record Resource;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetFilteredRes(ResAttributeValueMapping, TempFilteredRes, AttributeValueIDFilter, IsHandled);
        if IsHandled then
            exit;

        ResAttributeValueMapping.SetFilter("Resource Attribute Value ID", AttributeValueIDFilter);

        if ResAttributeValueMapping.IsEmpty() then begin
            TempFilteredRes.Reset();
            TempFilteredRes.DeleteAll();
            exit;
        end;

        if not TempFilteredRes.FindSet() then begin
            if ResAttributeValueMapping.FindSet() then
                repeat
                    Res.Get(ResAttributeValueMapping."No.");
                    TempFilteredRes.TransferFields(Res);
                    TempFilteredRes.Insert();
                until ResAttributeValueMapping.Next() = 0;
            exit;
        end;

        repeat
            ResAttributeValueMapping.SetRange("No.", TempFilteredRes."No.");
            if ResAttributeValueMapping.IsEmpty() then
                TempFilteredRes.Delete();
        until TempFilteredRes.Next() = 0;
        ResAttributeValueMapping.SetRange("No.");
    end;


    procedure GetResourceNoFilterText(var TempFilteredRes: Record Resource temporary; var ParameterCount: Integer) FilterText: Text
    var
        NextRes: Record Resource;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        PreviousNo: Text;
        ResNo: Text;
        FilterRangeStarted: Boolean;
    begin
        if not TempFilteredRes.FindSet() then begin
            FilterText := '<>*';
            exit;
        end;

        repeat
            ResNo := SelectionFilterManagement.AddQuotes(TempFilteredRes."No.");

            if FilterText = '' then begin
                FilterText := ResNo;
                NextRes."No." := TempFilteredRes."No.";
                ParameterCount += 1;
            end else begin
                if NextRes.Next() = 0 then
                    NextRes."No." := '';
                if TempFilteredRes."No." = NextRes."No." then begin
                    if not FilterRangeStarted then
                        FilterText += '..';
                    FilterRangeStarted := true;
                end else begin
                    if not FilterRangeStarted then begin
                        FilterText += StrSubstNo('|%1', ResNo);
                        ParameterCount += 1;
                    end else begin
                        FilterText += StrSubstNo('%1|%2', PreviousNo, ResNo);
                        FilterRangeStarted := false;
                        ParameterCount += 2;
                    end;
                    NextRes := TempFilteredRes;
                end;
            end;
            PreviousNo := ResNo;
        until TempFilteredRes.Next() = 0;

        // close range if needed
        if FilterRangeStarted then begin
            FilterText += StrSubstNo('%1', PreviousNo);
            ParameterCount += 1;
        end;
    end;


    procedure InheritAttributesFromResCategory(Res: Record Resource; NewResCategoryCode: Code[20]; OldResCategoryCode: Code[20])
    var
        TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary;
        TempResAttributeValueToDelete: Record "Resource Attribute Value" temporary;
        IsHandled: Boolean;
    begin
        //OnBeforeInheritAttributesFromResCategory(Res, NewResCategoryCode, OldResCategoryCode, IsHandled);
        if IsHandled then
            exit;

        GenerateAttributesToInsertAndToDelete(
          TempResAttributeValueToInsert, TempResAttributeValueToDelete, NewResCategoryCode, OldResCategoryCode);

        if not TempResAttributeValueToDelete.IsEmpty() then
            if not GuiAllowed then
                DeleteResAttributeValueMapping(Res, TempResAttributeValueToDelete)
            else
                if Confirm(StrSubstNo(DeleteAttributesInheritedFromOldCategoryQst, OldResCategoryCode)) then
                    DeleteResAttributeValueMapping(Res, TempResAttributeValueToDelete);

        if not TempResAttributeValueToInsert.IsEmpty() then
            InsertResAttributeValueMapping(Res, TempResAttributeValueToInsert);

        //OnAfterInheritAttributesFromResCategory(Res, NewResCategoryCode, OldResCategoryCode);
    end;



    procedure UpdateCategoryAttributesAfterChangingParentCategory(ResCategoryCode: Code[20]; NewParentResCategory: Code[20]; OldParentResCategory: Code[20])
    var
        TempNewParentResAttributeValue: Record "Resource Attribute Value" temporary;
        TempOldParentResAttributeValue: Record "Resource Attribute Value" temporary;
    begin
        TempNewParentResAttributeValue.LoadCategoryAttributesFactBoxData(NewParentResCategory);
        TempOldParentResAttributeValue.LoadCategoryAttributesFactBoxData(OldParentResCategory);
        UpdateCategoryResAttributeValueMapping(
          TempNewParentResAttributeValue, TempOldParentResAttributeValue, ResCategoryCode, OldParentResCategory);
    end;


    local procedure GenerateAttributesToInsertAndToDelete(var TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary; var TempResAttributeValueToDelete: Record "Resource Attribute Value" temporary; NewResCategoryCode: Code[20]; OldResCategoryCode: Code[20])
    var
        TempNewCategResAttributeValue: Record "Resource Attribute Value" temporary;
        TempOldCategResAttributeValue: Record "Resource Attribute Value" temporary;
    begin
        TempNewCategResAttributeValue.LoadCategoryAttributesFactBoxData(NewResCategoryCode);
        TempOldCategResAttributeValue.LoadCategoryAttributesFactBoxData(OldResCategoryCode);
        GenerateAttributeDifference(TempNewCategResAttributeValue, TempOldCategResAttributeValue, TempResAttributeValueToInsert);
        GenerateAttributeDifference(TempOldCategResAttributeValue, TempNewCategResAttributeValue, TempResAttributeValueToDelete);
    end;


    local procedure GenerateAttributeDifference(var TempFirstResAttributeValue: Record "Resource Attribute Value" temporary; var TempSecondResAttributeValue: Record "Resource Attribute Value" temporary; var TempResultingResAttributeValue: Record "Resource Attribute Value" temporary)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGenerateAttributeDifference(TempFirstResAttributeValue, TempSecondResAttributeValue, TempResultingResAttributeValue, IsHandled);
        if IsHandled then
            exit;

        if TempFirstResAttributeValue.FindFirst() then
            repeat
                if not TempSecondResAttributeValue.Get(TempFirstResAttributeValue."Attribute ID", TempFirstResAttributeValue.ID) then begin
                    TempResultingResAttributeValue.TransferFields(TempFirstResAttributeValue);
                    TempResultingResAttributeValue.Insert();
                end;
            until TempFirstResAttributeValue.Next() = 0;
    end;


    procedure DeleteResAttributeValueMapping(Res: Record Resource; var TempResAttributeValueToRemove: Record "Resource Attribute Value" temporary)
    begin
        DeleteResAttributeValueMappingWithTriggerOption(Res, TempResAttributeValueToRemove, true);
    end;


    local procedure DeleteResAttributeValueMappingWithTriggerOption(Res: Record Resource; var TempResAttributeValueToRemove: Record "Resource Attribute Value" temporary; RunTrigger: Boolean)
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttributeValuesToRemoveTxt: Text;
    begin
        ResAttributeValueMapping.SetRange("Table ID", DATABASE::Resource);
        ResAttributeValueMapping.SetRange("No.", Res."No.");
        if TempResAttributeValueToRemove.FindFirst() then begin
            repeat
                if ResAttributeValuesToRemoveTxt <> '' then
                    ResAttributeValuesToRemoveTxt += StrSubstNo('|%1', TempResAttributeValueToRemove."Attribute ID")
                else
                    ResAttributeValuesToRemoveTxt := Format(TempResAttributeValueToRemove."Attribute ID");
            until TempResAttributeValueToRemove.Next() = 0;
            ResAttributeValueMapping.SetFilter("Resource Attribute ID", ResAttributeValuesToRemoveTxt);
            ResAttributeValueMapping.DeleteAll(RunTrigger);
        end;
    end;


    local procedure InsertResAttributeValueMapping(Res: Record Resource; var TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary)
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
    begin
        if TempResAttributeValueToInsert.FindFirst() then
            repeat
                ResAttributeValueMapping."Table ID" := DATABASE::Resource;
                ResAttributeValueMapping."No." := Res."No.";
                ResAttributeValueMapping."Resource Attribute ID" := TempResAttributeValueToInsert."Attribute ID";
                ResAttributeValueMapping."Resource Attribute Value ID" := TempResAttributeValueToInsert.ID;
                //OnBeforeResAttributeValueMappingInsert(ResAttributeValueMapping, TempResAttributeValueToInsert);
                if ResAttributeValueMapping.Insert(true) then;
            until TempResAttributeValueToInsert.Next() = 0;
    end;


    procedure UpdateCategoryResAttributeValueMapping(var TempNewResAttributeValue: Record "Resource Attribute Value" temporary; var TempOldResAttributeValue: Record "Resource Attribute Value" temporary; ResCategoryCode: Code[20]; OldResCategoryCode: Code[20])
    var
        TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary;
        TempResAttributeValueToDelete: Record "Resource Attribute Value" temporary;
    begin
        GenerateAttributeDifference(TempNewResAttributeValue, TempOldResAttributeValue, TempResAttributeValueToInsert);
        GenerateAttributeDifference(TempOldResAttributeValue, TempNewResAttributeValue, TempResAttributeValueToDelete);

        if not TempResAttributeValueToDelete.IsEmpty() then
            if not GuiAllowed then
                DeleteCategoryResAttributeValueMapping(TempResAttributeValueToDelete, ResCategoryCode)
            else
                if Confirm(StrSubstNo(DeleteResInheritedParentCategoryAttributesQst, ResCategoryCode, OldResCategoryCode)) then
                    DeleteCategoryResAttributeValueMapping(TempResAttributeValueToDelete, ResCategoryCode);

        if not TempResAttributeValueToInsert.IsEmpty() then
            InsertCategoryResAttributeValueMapping(TempResAttributeValueToInsert, ResCategoryCode);
    end;


    procedure DeleteCategoryResAttributeValueMapping(var TempResAttributeValueToRemove: Record "Resource Attribute Value" temporary; CategoryCode: Code[20])
    var
        Res: Record Resource;
        ResCategory: Record "Resource Category";
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttributeValue: Record "Resource Attribute Value";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeDeleteCategoryResAttributeValueMapping(TempResAttributeValueToRemove, CategoryCode, IsHandled);
        if IsHandled then
            exit;

        Res.SetRange("Resource Category Code", CategoryCode);
        if Res.FindSet() then
            repeat
                DeleteResAttributeValueMappingWithTriggerOption(Res, TempResAttributeValueToRemove, false);
            until Res.Next() = 0;

        ResCategory.SetRange("Parent Category", CategoryCode);
        if ResCategory.FindSet() then
            repeat
                DeleteCategoryResAttributeValueMapping(TempResAttributeValueToRemove, ResCategory.Code);
            until ResCategory.Next() = 0;

        if TempResAttributeValueToRemove.FindSet() then
            repeat
                ResAttributeValueMapping.SetRange("Resource Attribute ID", TempResAttributeValueToRemove."Attribute ID");
                ResAttributeValueMapping.SetRange("Resource Attribute Value ID", TempResAttributeValueToRemove.ID);
                if ResAttributeValueMapping.IsEmpty() then
                    if ResAttributeValue.Get(TempResAttributeValueToRemove."Attribute ID", TempResAttributeValueToRemove.ID) then
                        ResAttributeValue.Delete();
            until TempResAttributeValueToRemove.Next() = 0;
    end;


    procedure InsertCategoryResAttributeValueMapping(var TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary; CategoryCode: Code[20])
    var
        Res: Record Resource;
        ResCategory: Record "Resource Category";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInsertCategoryResAttributeValueMapping(TempResAttributeValueToInsert, CategoryCode, IsHandled);
        if IsHandled then
            exit;

        Res.SetRange("Resource Category Code", CategoryCode);
        if Res.FindSet() then
            repeat
                InsertResAttributeValueMapping(Res, TempResAttributeValueToInsert);
            until Res.Next() = 0;

        ResCategory.SetRange("Parent Category", CategoryCode);
        if ResCategory.FindSet() then
            repeat
                InsertCategoryResAttributeValueMapping(TempResAttributeValueToInsert, ResCategory.Code);
            until ResCategory.Next() = 0;
    end;


    procedure InsertCategoryResBufferedAttributeValueMapping(var TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary; var TempInsertedResAttributeValueMapping: Record "Res. Attribute Value Mapping" temporary; CategoryCode: Code[20])
    var
        Res: Record Resource;
        ResCategory: Record "Resource Category";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInsertCategoryResBufferedAttributeValueMapping(TempResAttributeValueToInsert, TempInsertedResAttributeValueMapping, CategoryCode, IsHandled);
        if IsHandled then
            exit;

        Res.SetRange("Resource Category Code", CategoryCode);
        if Res.FindSet() then
            repeat
                InsertBufferedResAttributeValueMapping(Res, TempResAttributeValueToInsert, TempInsertedResAttributeValueMapping);
            until Res.Next() = 0;

        ResCategory.SetRange("Parent Category", CategoryCode);
        if ResCategory.FindSet() then
            repeat
                InsertCategoryResBufferedAttributeValueMapping(
                  TempResAttributeValueToInsert, TempInsertedResAttributeValueMapping, ResCategory.Code);
            until ResCategory.Next() = 0;
    end;


    local procedure InsertBufferedResAttributeValueMapping(Res: Record Resource; var TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary; var TempInsertedResAttributeValueMapping: Record "Res. Attribute Value Mapping" temporary)
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
    begin
        if TempResAttributeValueToInsert.FindFirst() then
            repeat
                ResAttributeValueMapping."Table ID" := DATABASE::Resource;
                ResAttributeValueMapping."No." := Res."No.";
                ResAttributeValueMapping."Resource Attribute ID" := TempResAttributeValueToInsert."Attribute ID";
                ResAttributeValueMapping."Resource Attribute Value ID" := TempResAttributeValueToInsert.ID;
                OnInsertBufferedResAttributeValueMappingOnBeforeResAttributeValueMappingInsert(TempResAttributeValueToInsert, ResAttributeValueMapping);
                if ResAttributeValueMapping.Insert(true) then begin
                    TempInsertedResAttributeValueMapping.TransferFields(ResAttributeValueMapping);
                    OnBeforeBufferedResAttributeValueMappingInsert(ResAttributeValueMapping, TempInsertedResAttributeValueMapping);
                    TempInsertedResAttributeValueMapping.Insert();
                end;
            until TempResAttributeValueToInsert.Next() = 0;
    end;


    procedure SearchCategoryResForAttribute(CategoryCode: Code[20]; AttributeID: Integer): Boolean
    var
        Res: Record Resource;
        ResCategory: Record "Resource Category";
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        IsHandled: Boolean;
        ReturnValue: Boolean;
    begin
        Res.SetRange("Resource Category Code", CategoryCode);
        if Res.FindSet() then
            repeat
                ResAttributeValueMapping.SetRange("Table ID", DATABASE::Resource);
                ResAttributeValueMapping.SetRange("No.", Res."No.");
                ResAttributeValueMapping.SetRange("Resource Attribute ID", AttributeID);
                if not ResAttributeValueMapping.IsEmpty() then
                    exit(true);
            until Res.Next() = 0;

        IsHandled := false;
        OnSearchCategoryResForAttributeOnBeforeSearchByParentCategory(CategoryCode, AttributeID, IsHandled, ReturnValue);
        if IsHandled then
            exit(ReturnValue);

        ResCategory.SetRange("Parent Category", CategoryCode);
        if ResCategory.FindSet() then
            repeat
                if SearchCategoryResForAttribute(ResCategory.Code, AttributeID) then
                    exit(true);
            until ResCategory.Next() = 0;
    end;


    procedure DoesValueExistInResAttributeValues(Text: Text[250]; var ResAttributeValue: Record "Resource Attribute Value"): Boolean
    begin
        ResAttributeValue.Reset();
        ResAttributeValue.SetFilter(Value, '@' + Text);
        exit(ResAttributeValue.FindSet());
    end;


    procedure GetResNoFilterText(var TempFilteredRes: Record Resource temporary; var ParameterCount: Integer) FilterText: Text
    var
        NextRes: Record Resource;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        PreviousNo: Text;
        ResNo: Text;
        FilterRangeStarted: Boolean;
    begin
        if not TempFilteredRes.FindSet() then begin
            FilterText := '<>*';
            exit;
        end;

        repeat
            ResNo := SelectionFilterManagement.AddQuotes(TempFilteredRes."No.");

            if FilterText = '' then begin
                FilterText := ResNo;
                NextRes."No." := TempFilteredRes."No.";
                ParameterCount += 1;
            end else begin
                if NextRes.Next() = 0 then
                    NextRes."No." := '';
                if TempFilteredRes."No." = NextRes."No." then begin
                    if not FilterRangeStarted then
                        FilterText += '..';
                    FilterRangeStarted := true;
                end else begin
                    if not FilterRangeStarted then begin
                        FilterText += StrSubstNo('|%1', ResNo);
                        ParameterCount += 1;
                    end else begin
                        FilterText += StrSubstNo('%1|%2', PreviousNo, ResNo);
                        FilterRangeStarted := false;
                        ParameterCount += 2;
                    end;
                    NextRes := TempFilteredRes;
                end;
            end;
            PreviousNo := ResNo;
        until TempFilteredRes.Next() = 0;

        // close range if needed
        if FilterRangeStarted then begin
            FilterText += StrSubstNo('%1', PreviousNo);
            ParameterCount += 1;
        end;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeResAttributeValueMappingInsert(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; var TempResAttributeValue: Record "Resource Attribute Value" temporary)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertCategoryResAttributeValueMapping(var TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary; CategoryCode: Code[20]; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertCategoryResBufferedAttributeValueMapping(var TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary; var TempInsertedResAttributeValueMapping: Record "Res. Attribute Value Mapping" temporary; CategoryCode: Code[20]; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeBufferedResAttributeValueMappingInsert(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; var TempResAttributeValueMapping: Record "Res. Attribute Value Mapping" temporary)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteCategoryResAttributeValueMapping(var TempResAttributeValueToRemove: Record "Resource Attribute Value" temporary; CategoryCode: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGenerateAttributeDifference(var TempFirstResAttributeValue: Record "Resource Attribute Value" temporary; var TempSecondResAttributeValue: Record "Resource Attribute Value" temporary; var TempResultingResAttributeValue: Record "Resource Attribute Value" temporary; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetFilteredRes(var ResAttributeValueMapping: Record "Res. Attribute Value Mapping"; var TempFilteredRes: Record Resource temporary; AttributeValueIDFilter: Text; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnFindResByAttributesOnBeforeFilterResAttributesBufferLoop(var FilterResAttributesBuffer: Record "Filter Res. Attributes Buffer"; var TempFilteredRes: Record Resource temporary; var ResAttributeValueMapping: Record "Res. Attribute Value Mapping")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnInsertBufferedResAttributeValueMappingOnBeforeResAttributeValueMappingInsert(var TempResAttributeValueToInsert: Record "Resource Attribute Value" temporary; var ResAttributeValueMapping: Record "Res. Attribute Value Mapping")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnSearchCategoryResForAttributeOnBeforeSearchByParentCategory(CategoryCode: Code[20]; AttributeID: Integer; var IsHandled: Boolean; var ReturnValue: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeInheritAttributesFromResCategory(Res: Record Resource; NewResCategoryCode: Code[20]; OldResCategoryCode: Code[20]; var Handle: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterInheritAttributesFromResCategory(Res: Record Resource; NewResCategoryCode: Code[20]; OldResCategoryCode: Code[20])
    begin
    end;
}