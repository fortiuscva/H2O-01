pageextension 50119 "Resource List Ext" extends "Resource List"
{
    layout
    {
        addfirst(factboxes)
        {
            part(ResAttributesFactbox; "Resource Attributes Factbox")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(navigation)
        {
            action(Attributes)
            {
                //AccessByPermission = TableData "Resource Attribute" = R;
                ApplicationArea = All;
                Caption = 'Attributes';
                Image = Category;
                ToolTip = 'View or edit the resource''s attributes, such as color, size, or other characteristics that help to describe the resource.';

                trigger OnAction()
                begin
                    PAGE.RunModal(PAGE::"Res. Attribute Value Editor", Rec);
                    CurrPage.SaveRecord();
                    CurrPage.ResAttributesFactbox.PAGE.LoadResAttributesData(rec."No.");
                end;
            }
            action(FilterByAttributes)
            {
                //AccessByPermission = TableData "Resource Attribute" = R;
                ApplicationArea = All;
                Caption = 'Filter by Attributes';
                Image = EditFilter;
                ToolTip = 'Find resources that match specific attributes. To make sure you include recent changes made by other users, clear the filter and then reset it.';

                trigger OnAction()
                var
                    ResAttributeManagement: Codeunit "Resource Attribute Management";
                    TypeHelper: Codeunit "Type Helper";
                    CloseAction: Action;
                    FilterText: Text;
                    FilterPageID: Integer;
                    ParameterCount: Integer;
                begin
                    FilterPageID := PAGE::"Filter Resources by Attribute";
                    if ClientTypeManagement.GetCurrentClientType() = CLIENTTYPE::Phone then
                        FilterPageID := PAGE::"Filter Res. by Att. Phone";

                    CloseAction := PAGE.RunModal(FilterPageID, TempFilterResAttributesBuffer);
                    if (ClientTypeManagement.GetCurrentClientType() <> CLIENTTYPE::Phone) and (CloseAction <> ACTION::LookupOK) then
                        exit;

                    if TempFilterResAttributesBuffer.IsEmpty() then begin
                        ClearAttributesFilter();
                        exit;
                    end;
                    TempResFilteredFromAttributes.Reset();
                    TempResFilteredFromAttributes.DeleteAll();
                    ResAttributeManagement.FindResByAttributes(TempFilterResAttributesBuffer, TempResFilteredFromAttributes);
                    FilterText := ResAttributeManagement.GetResNoFilterText(TempResFilteredFromAttributes, ParameterCount);

                    if ParameterCount < TypeHelper.GetMaxNumberOfParametersInSQLQuery() - 100 then begin
                        rec.FilterGroup(0);
                        rec.MarkedOnly(false);
                        rec.SetFilter("No.", FilterText);
                    end else begin
                        RunOnTempRec := true;
                        rec.ClearMarks();
                        rec.Reset();
                    end;
                end;
            }
            action(ClearAttributes)
            {
                //AccessByPermission = TableData "Resource Attribute" = R;
                ApplicationArea = All;
                Caption = 'Clear Attributes Filter';
                Image = RemoveFilterLines;
                ToolTip = 'Remove the filter for specific resource attributes.';

                trigger OnAction()
                begin
                    ClearAttributesFilter();
                    TempResFilteredFromAttributes.Reset();
                    TempResFilteredFromAttributes.DeleteAll();
                    RunOnTempRec := false;

                    RestoreTempResFilteredFromAttributes();
                end;
            }
        }
    }



    var
        ClientTypeManagement: Codeunit "Client Type Management";
        TempFilterResAttributesBuffer: Record "Filter Res. Attributes Buffer" temporary;
        TempResFilteredFromAttributes: Record Resource temporary;
        TempResFilteredFromPickRes: Record Resource temporary;
        RunOnPickRes: Boolean;
        RunOnTempRec: Boolean;



    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.ResAttributesFactBox.PAGE.LoadResAttributesData(rec."No.");
    end;



    local procedure ClearAttributesFilter()
    begin
        rec.ClearMarks();
        rec.MarkedOnly(false);
        TempFilterResAttributesBuffer.Reset();
        TempFilterResAttributesBuffer.DeleteAll();
        rec.FilterGroup(0);
        rec.SetRange(rec."No.");
    end;


    local procedure RestoreTempResFilteredFromAttributes()
    begin
        if not RunOnPickRes then
            exit;

        TempResFilteredFromAttributes.Reset();
        TempResFilteredFromAttributes.DeleteAll();
        RunOnTempRec := true;

        if TempResFilteredFromPickRes.FindSet() then
            repeat
                TempResFilteredFromAttributes := TempResFilteredFromPickRes;
                TempResFilteredFromAttributes.Insert();
            until TempResFilteredFromPickRes.Next() = 0;
    end;


    procedure SetTempFilteredResRec(var Res: Record Resource)
    begin
        TempResFilteredFromAttributes.Reset();
        TempResFilteredFromAttributes.DeleteAll();

        TempResFilteredFromPickRes.Reset();
        TempResFilteredFromPickRes.DeleteAll();

        RunOnTempRec := true;
        RunOnPickRes := true;

        if Res.FindSet() then
            repeat
                TempResFilteredFromAttributes := Res;
                TempResFilteredFromAttributes.Insert();
                TempResFilteredFromPickRes := Res;
                TempResFilteredFromPickRes.Insert();
            until Res.Next() = 0;
    end;

}

