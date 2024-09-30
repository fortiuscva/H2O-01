codeunit 50114 "Resource Category Management"
{
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin
    end;


    var
        TempResCategory: Record "Resource Category" temporary;


    procedure UpdatePresentationOrder()
    var
        ResCategory: Record "Resource Category";
    begin
        TempResCategory.Reset();
        TempResCategory.DeleteAll();

        // This is to cleanup wrong created blank entries created by an import mistake
        if ResCategory.Get('') then
            ResCategory.Delete();

        //if ResCategory.Findset(false, false) then
        if ResCategory.Findset then
            repeat
                TempResCategory.TransferFields(ResCategory);
                TempResCategory.Insert();
            until ResCategory.Next() = 0;
        UpdatePresentationOrderIterative();
    end;


    local procedure UpdatePresentationOrderIterative()
    var
        ResCategory: Record "Resource Category";
        TempStack: Record TempStack temporary;
        TempCurResCategory: Record "Resource Category" temporary;
        CurResCategoryID: RecordID;
        PresentationOrder: Integer;
        Indentation: Integer;
        HasChildren: Boolean;
    begin
        PresentationOrder := 0;

        TempCurResCategory.Copy(TempResCategory, true);

        TempResCategory.SetCurrentKey("Parent Category");
        TempResCategory.Ascending(false);
        TempResCategory.SetRange("Parent Category", '');
        if TempResCategory.FindSet then
            repeat
                TempStack.Push(TempResCategory.RecordId());
            until TempResCategory.Next() = 0;

        while TempStack.Pop(CurResCategoryID) do begin
            TempCurResCategory.Get(CurResCategoryID);
            HasChildren := false;

            TempResCategory.SetRange("Parent Category", TempCurResCategory.Code);
            if TempResCategory.FindSet then
                repeat
                    TempStack.Push(TempResCategory.RecordId());
                    HasChildren := true;
                until TempResCategory.Next() = 0;

            if TempCurResCategory."Parent Category" <> '' then begin
                TempResCategory.Get(TempCurResCategory."Parent Category");
                Indentation := TempResCategory.Indentation + 1;
            end else
                Indentation := 0;
            PresentationOrder := PresentationOrder + 10000;

            if (TempCurResCategory."Presentation Order" <> PresentationOrder) or
               (TempCurResCategory.Indentation <> Indentation) or (TempCurResCategory."Has Children" <> HasChildren)
            then begin
                ResCategory.Get(TempCurResCategory.Code);
                ResCategory.Validate("Presentation Order", PresentationOrder);
                ResCategory.Validate(Indentation, Indentation);
                ResCategory.Validate("Has Children", HasChildren);
                ResCategory.Modify();
                TempResCategory.Get(TempCurResCategory.Code);
                TempResCategory.Validate("Presentation Order", PresentationOrder);
                TempResCategory.Validate(Indentation, Indentation);
                TempResCategory.Validate("Has Children", HasChildren);
                TempResCategory.Modify();
            end;
        end;
    end;


    procedure DoesValueExistInResCategories(Text: Code[20]; var ResCategory: Record "Resource Category"): Boolean
    begin
        ResCategory.Reset();
        ResCategory.SetFilter(Code, '@' + Text);
        exit(ResCategory.FindSet());
    end;


    procedure FindMatchInCategories(SearchTerm: Text; var ResCategory: Record "Resource Category"; ExactMatchOnly: Boolean): Boolean
    var
        FilterPattern: Text;
    begin
        SearchTerm := DelChr(SearchTerm, '=', '.&|<>=*@()?%#''');

        if SearchTerm = '' then
            exit(false);

        if ExactMatchOnly then
            FilterPattern := '@%1'
        else
            FilterPattern := '@*%1*';

        ResCategory.Reset();
        ResCategory.SetFilter(Code, StrSubstNo(FilterPattern, CopyStr(SearchTerm, 1, MaxStrLen(ResCategory.Code))));
        ResCategory.SetCurrentKey(Indentation);
        ResCategory.SetAscending(Indentation, false);
        if ResCategory.FindFirst() then
            exit(true);

        ResCategory.Reset();
        ResCategory.SetFilter(Description, StrSubstNo(FilterPattern, CopyStr(SearchTerm, 1, MaxStrLen(ResCategory.Description))));
        ResCategory.SetCurrentKey(Indentation);
        ResCategory.SetAscending(Indentation, false);
        if ResCategory.FindFirst() then
            exit(true);

        exit(false);
    end;


    [Scope('OnPrem')]
    procedure CalcPresentationOrder(var ResCategory: Record "Resource Category")
    var
        ResCategorySearch: Record "Resource Category";
        ResCategoryPrev: Record "Resource Category";
        ResCategoryNext: Record "Resource Category";
        ResCategoryPrevExists: Boolean;
        ResCategoryNextExists: Boolean;
    begin
        if ResCategory.HasChildren() then begin
            ResCategory."Presentation Order" := 0;
            exit;
        end;

        ResCategoryPrev.SetRange("Parent Category", ResCategory."Parent Category");
        ResCategoryPrev.SetFilter(Code, '<%1', ResCategory.Code);
        ResCategoryPrevExists := ResCategoryPrev.FindLast();
        if not ResCategoryPrevExists then
            ResCategoryPrevExists := ResCategoryPrev.Get(ResCategory."Parent Category")
        else
            ResCategoryPrev.Get(GetLastChildCode(ResCategoryPrev.Code));

        ResCategoryNext.SetRange("Parent Category", ResCategory."Parent Category");
        ResCategoryNext.SetFilter(Code, '>%1', ResCategory.Code);
        ResCategoryNextExists := ResCategoryNext.FindFirst();
        if not ResCategoryNextExists and ResCategoryPrevExists then begin
            ResCategoryNext.Reset();
            ResCategoryNext.SetCurrentKey("Presentation Order");
            ResCategoryNext.SetFilter(Code, '<>%1', ResCategory.Code);
            ResCategoryNext.SetFilter("Presentation Order", '>%1', ResCategoryPrev."Presentation Order");
            ResCategoryNextExists := ResCategoryNext.FindFirst();
        end;

        case true of
            not ResCategoryPrevExists and not ResCategoryNextExists:
                ResCategory."Presentation Order" := 10000;
            not ResCategoryPrevExists and ResCategoryNextExists:
                ResCategory."Presentation Order" := ResCategoryNext."Presentation Order" div 2;
            ResCategoryPrevExists and not ResCategoryNextExists:
                ResCategory."Presentation Order" := ResCategoryPrev."Presentation Order" + 10000;
            ResCategoryPrevExists and ResCategoryNextExists:
                ResCategory."Presentation Order" := (ResCategoryPrev."Presentation Order" + ResCategoryNext."Presentation Order") div 2;
        end;

        ResCategorySearch.SetRange("Presentation Order", ResCategory."Presentation Order");
        ResCategorySearch.SetFilter(Code, '<>%1', ResCategory.Code);
        if not ResCategorySearch.IsEmpty() then
            ResCategory."Presentation Order" := 0;
    end;


    [Scope('OnPrem')]
    procedure CheckPresentationOrder()
    var
        ResCategory: Record "Resource Category";
    begin
        ResCategory.SetRange("Presentation Order", 0);
        if not ResCategory.IsEmpty() then
            UpdatePresentationOrder();
    end;


    local procedure GetLastChildCode(ParentCode: Code[20]) ChildCode: Code[20]
    var
        TempStack: Record TempStack temporary;
        ResCategory: Record "Resource Category";
        RecId: RecordID;
    begin
        ChildCode := ParentCode;

        ResCategory.Ascending(false);
        ResCategory.SetRange("Parent Category", ParentCode);
        if ResCategory.FindSet() then
            repeat
                TempStack.Push(ResCategory.RecordId());
            until ResCategory.Next() = 0;

        while TempStack.Pop(RecId) do begin
            ResCategory.Get(RecId);
            ChildCode := ResCategory.Code;

            ResCategory.SetRange("Parent Category", ResCategory.Code);
            if ResCategory.FindSet() then
                repeat
                    TempStack.Push(ResCategory.RecordId());
                until ResCategory.Next() = 0;
        end;
    end;
}