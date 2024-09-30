page 50122 "Filter Res. by Att. Phone"
{
    Caption = 'Filter Resources by Attribute';
    DataCaptionExpression = '';
    PageType = List;
    SourceTable = "Filter Res. Attributes Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field(Attribute; rec.Attribute)
                {
                    ApplicationArea = All;
                    TableRelation = "Resource Attribute".Name;
                    ToolTip = 'Specifies the name of the attribute to filter on.';
                }
                field(Value; rec.Value)
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    ToolTip = 'Specifies the value of the filter. You can use single values or filter expressions, such as >,<,>=,<=,|,&, and 1..100.';

                    trigger OnAssistEdit()
                    begin
                        rec.ValueAssistEdit();
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        rec.SetRange(Value, '');
        rec.DeleteAll();
    end;
}

