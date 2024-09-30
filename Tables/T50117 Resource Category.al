table 50117 "Resource Category"
{
    Caption = 'Resource Category';
    LookupPageID = "Resource Categories";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; "Parent Category"; Code[20])
        {
            Caption = 'Parent Category';
            TableRelation = "Resource Category";

            trigger OnValidate()
            var
                ResCategory: Record "Resource Category";
                ResAttributeManagement: Codeunit "Resource Attribute Management";
                ParentCategory: Code[20];
            begin
                ParentCategory := "Parent Category";
                while ResCategory.Get(ParentCategory) do begin
                    if ResCategory.Code = Code then
                        Error(CyclicInheritanceErr);
                    ParentCategory := ResCategory."Parent Category";
                end;
                if "Parent Category" <> xRec."Parent Category" then
                    ResAttributeManagement.UpdateCategoryAttributesAfterChangingParentCategory(Code, "Parent Category", xRec."Parent Category");
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
        }
        field(10; "Presentation Order"; Integer)
        {
            Caption = 'Presentation Order';
        }
        field(11; "Has Children"; Boolean)
        {
            Caption = 'Has Children';
        }
        field(12; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Parent Category")
        {
        }
        key(Key3; "Presentation Order")
        {
        }
        key(Key4; Indentation, Code, Description)
        {
        }
    }



    fieldgroups
    {
    }



    trigger OnDelete()
    begin
        if HasChildren() then
            Error(DeleteWithChildrenErr);
        UpdateDeletedCategoryRess();
        DeleteAssignedAttributes();
    end;



    trigger OnInsert()
    begin
        TestField(Code);
        //UpdateIndentation();
        //ResCategoryManagement.CalcPresentationOrder(Rec);
        "Last Modified Date Time" := CurrentDateTime;
    end;



    trigger OnModify()
    begin
        //UpdateIndentation();
        //ResCategoryManagement.CalcPresentationOrder(Rec);
        "Last Modified Date Time" := CurrentDateTime;
    end;



    trigger OnRename()
    begin
        "Presentation Order" := 0;
        "Last Modified Date Time" := CurrentDateTime;
    end;


    var
        ResCategoryManagement: Codeunit "Resource Category Management";
        CyclicInheritanceErr: Label 'A resource category cannot be a parent of itself or any of its children.';
        DeleteWithChildrenErr: Label 'You cannot delete this resource category because it has child resource categories.';
        DeleteResInheritedAttributesQst: Label 'One or more resources belong to resource category ''''%1''''.\\Do you want to delete the inherited resource attributes for the resources in question? ', Comment = '%1 - Resource category code';



    procedure HasChildren(): Boolean
    var
        ResCategory: Record "Resource Category";
    begin
        ResCategory.SetRange("Parent Category", Code);
        exit(not ResCategory.IsEmpty)
    end;



    procedure GetStyleText(): Text
    begin
        if Indentation = 0 then
            exit('Strong');

        if HasChildren() then
            exit('Strong');

        exit('');
    end;



    local procedure UpdateDeletedCategoryRess()
    var
        CategoryRes: Record Resource;
        TempCategoryResAttributeValue: Record "Resource Attribute Value" temporary;
        ResAttributeManagement: Codeunit "Resource Attribute Management";
        DeleteResInheritedAttributes: Boolean;
    begin
        CategoryRes.SetRange("Resource Category Code", Code);
        if CategoryRes.IsEmpty() then
            exit;
        DeleteResInheritedAttributes := Confirm(StrSubstNo(DeleteResInheritedAttributesQst, Code));
        if DeleteResInheritedAttributes then
            TempCategoryResAttributeValue.LoadCategoryAttributesFactBoxData(Code);
        if CategoryRes.Find('-') then
            repeat
                CategoryRes.Validate("Resource Category Code", '');
                CategoryRes.Modify();
                if DeleteResInheritedAttributes then
                    ResAttributeManagement.DeleteResAttributeValueMapping(CategoryRes, TempCategoryResAttributeValue);
            until CategoryRes.Next() = 0;
    end;



    local procedure DeleteAssignedAttributes()
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
    begin
        ResAttributeValueMapping.SetRange("Table ID", DATABASE::"Resource Category");
        ResAttributeValueMapping.SetRange("No.", Code);
        ResAttributeValueMapping.DeleteAll();
    end;



    /*
    local procedure UpdateIndentation()
    var
        ParentResCategory: Record "Resource Category";
    begin
        if ParentResCategory.Get("Parent Category") then
            UpdateIndentationTree(ParentResCategory.Indentation + 1)
        else
            UpdateIndentationTree(0);
    end;


    [Scope('OnPrem')]
    procedure UpdateIndentationTree(Level: Integer)
    var
        ResCategory: Record "Resource Category";
    begin
        Indentation := Level;

        ResCategory.SetRange("Parent Category", Code);
        if ResCategory.FindSet() then
            repeat
                ResCategory.UpdateIndentationTree(Level + 1);
                ResCategory.Modify();
            until ResCategory.Next() = 0;
    end;
    */
}