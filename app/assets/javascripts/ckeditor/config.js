CKEDITOR.editorConfig = function( config )
{
    config.filebrowserParams = function(){
        var csrf_token = $('meta[name=csrf-token]').attr('content'),
                csrf_param = $('meta[name=csrf-param]').attr('content'),
                params = new Object();

        if (csrf_param !== undefined && csrf_token !== undefined) {
            params[csrf_param] = csrf_token;
        }

        return params;
    };
    config.scayt_autoStartup = true;
    config.toolbar_MyToolbar =
    [
        { name: 'styles', items : ['Format','Bold','Italic'] },
        { name: 'clipboard', items : ['PasteText','PasteFromWord','-','Image','HorizontalRule','-','Undo','Redo' ] },
        { name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','Link','Unlink'] }
    ];
}
