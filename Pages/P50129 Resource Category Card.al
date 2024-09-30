page 50129 "Resource Category Card"
{
    Caption = 'Resource Category Card';
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Resource Category";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; rec.Code)
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ToolTip = 'Specifies the item category.';

                    trigger OnValidate()
                    begin
                        if (xRec.Code <> '') and (xRec.Code <> rec.Code) then
                            CurrPage.Attributes.PAGE.SaveAttributes(rec.Code);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the resource category.';
                }
                field("Parent Category"; Rec."Parent Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the resource category that this resource category belongs to. Resource attributes that are assigned to a parent resource category also apply to the child resource category.';

                    trigger OnValidate()
                    begin
                        if (rec.Code <> '') and (rec."Parent Category" <> xRec."Parent Category") then
                            PersistCategoryAttributes();
                    end;
                }
            }
            part(Attributes; "Res. Category Attributes")
            {
                ApplicationArea = All;
                Caption = 'Attributes';
                ShowFilter = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Delete)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Enabled = CanDelete;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    if Confirm(StrSubstNo(DeleteQst, rec.Code)) then
                        rec.Delete(true);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(Delete_Promoted; Delete)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if rec.Code <> '' then
            CurrPage.Attributes.PAGE.LoadAttributes(rec.Code);

        CanDelete := not rec.HasChildren();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage.Attributes.PAGE.SetResCategoryCode(rec.Code);
    end;

    trigger OnOpenPage()
    begin
        if rec.Code <> '' then
            CurrPage.Attributes.PAGE.LoadAttributes(rec.Code);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if rec.Code <> '' then
            CurrPage.Attributes.PAGE.SaveAttributes(rec.Code);

        //ResCategoryManagement.CheckPresentationOrder();
    end;

    var
        ResCategoryManagement: Codeunit "Resource Category Management";
        DeleteQst: Label 'Delete %1?', Comment = '%1 - item category name';
        CanDelete: Boolean;

    local procedure PersistCategoryAttributes()
    begin
        CurrPage.Attributes.PAGE.SaveAttributes(rec.Code);
        CurrPage.Attributes.PAGE.LoadAttributes(rec.Code);
        CurrPage.Update(true);
    end;
}

