page 50128 "Resource Categories"
{
    ApplicationArea = All;
    Caption = 'Resource Categories';
    CardPageID = "Resource Category Card";
    InsertAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Resource Category";
    SourceTableView = SORTING("Presentation Order");
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = rec.Indentation;
                IndentationControls = "Code";
                ShowAsTree = true;
                ShowCaption = false;
                field("Code"; rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the code for the item category.';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                        CurrPage.ResAttributesFactbox.PAGE.LoadCategoryAttributesData(rec.Code);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the resource category.';
                }
            }
        }
        area(factboxes)
        {
            part(ResAttributesFactbox; "Resource Attributes Factbox")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Attributes';
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Recalculate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Recalculate';
                Image = Hierarchy;
                ToolTip = 'Update the tree of resource categories based on recent changes.';

                trigger OnAction()
                begin
                    ResCategoryManagement.UpdatePresentationOrder();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(Recalculate_Promoted; Recalculate)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        StyleTxt := rec.GetStyleText();
        CurrPage.ResAttributesFactbox.PAGE.LoadCategoryAttributesData(rec.Code);
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := rec.GetStyleText();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        StyleTxt := rec.GetStyleText();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        StyleTxt := rec.GetStyleText();
    end;

    trigger OnOpenPage()
    begin
        //ResCategoryManagement.CheckPresentationOrder();
    end;

    protected var
        ResCategoryManagement: Codeunit "Resource Category Management";
        StyleTxt: Text;

    procedure GetSelectionFilter(): Text
    var
        ResCategory: Record "Resource Category";
        SelectionFilterManagement: Codeunit SelectionFilterMgmt;
    begin
        CurrPage.SetSelectionFilter(ResCategory);
        exit(SelectionFilterManagement.GetSelectionFilterForResCategory(ResCategory));
    end;

    procedure SetSelection(var ResCategory: Record "Resource Category")
    begin
        CurrPage.SetSelectionFilter(ResCategory);
    end;
}

