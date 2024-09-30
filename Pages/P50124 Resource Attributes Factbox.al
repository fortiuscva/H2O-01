page 50124 "Resource Attributes Factbox"
{
    Caption = 'Resource Attributes';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Resource Attribute Value";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field(Attribute; rec.GetAttributeNameInCurrentLanguage())
                {
                    ApplicationArea = All;
                    Caption = 'Attribute';
                    ToolTip = 'Specifies the name of the resource attribute.';
                    Visible = TranslatedValuesVisible;
                }
                field(Value; rec.GetValueInCurrentLanguage())
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    ToolTip = 'Specifies the value of the resource attribute.';
                    Visible = TranslatedValuesVisible;
                }
                field("Attribute Name"; Rec."Attribute Name")
                {
                    ApplicationArea = All;
                    Caption = 'Attribute';
                    ToolTip = 'Specifies the name of the resource attribute.';
                    Visible = NOT TranslatedValuesVisible;
                }
                field(RawValue; rec.Value)
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    ToolTip = 'Specifies the value of the resource attribute.';
                    Visible = NOT TranslatedValuesVisible;
                }
            }
        }
    }


    actions
    {
        area(processing)
        {
            action(Edit)
            {
                //AccessByPermission = TableData "Resource Attribute" = R;
                ApplicationArea = All;
                Caption = 'Edit';
                Image = Edit;
                ToolTip = 'Edit Resource''s attributes, such as color, size, or other characteristics that help to describe the resource.';
                Visible = IsRes;

                trigger OnAction()
                var
                    Res: Record Resource;
                begin
                    if not IsRes then
                        exit;
                    if not Res.Get(ContextValue) then
                        exit;
                    PAGE.RunModal(PAGE::"Res. Attribute Value Editor", Res);
                    CurrPage.SaveRecord();
                    LoadResAttributesData(ContextValue);
                end;
            }
        }
    }


    trigger OnOpenPage()
    begin
        rec.SetAutoCalcFields("Attribute Name");
        TranslatedValuesVisible := ClientTypeManagement.GetCurrentClientType() <> CLIENTTYPE::Phone;
        IsVisible := true;
        if ResAttCode <> '' then begin
            LoadResAttributesData(ResAttCode);
            ResAttCode := '';
        end;

        if CategoryAttCode <> '' then begin
            LoadCategoryAttributesData(CategoryAttCode);
            CategoryAttCode := '';
        end;
    end;



    var
        ClientTypeManagement: Codeunit "Client Type Management";
        ContextType: Option "None",Resource,Category;
        ContextValue: Code[20];
        IsRes: Boolean;
        IsVisible: Boolean;
        ResAttCode: Code[20];
        CategoryAttCode: Code[20];


    protected var
        TranslatedValuesVisible: Boolean;



    procedure LoadResAttributesData(KeyValue: Code[20])
    begin
        if not IsVisible then begin
            ResAttCode := KeyValue;
            exit;
        end;
        rec.LoadResAttributesFactBoxData(KeyValue);
        SetContext(ContextType::Resource, KeyValue);
        CurrPage.Update(false);
    end;


    procedure LoadCategoryAttributesData(CategoryCode: Code[20])
    begin
        if not IsVisible then begin
            CategoryAttCode := CategoryCode;
            exit;
        end;
        rec.LoadCategoryAttributesFactBoxData(CategoryCode);
        SetContext(ContextType::Category, CategoryCode);
        CurrPage.Update(false);
    end;


    local procedure SetContext(NewType: Option; NewValue: Code[20])
    begin
        ContextType := NewType;
        ContextValue := NewValue;
        IsRes := ContextType = ContextType::Resource;
    end;
}