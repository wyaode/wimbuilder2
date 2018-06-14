var selected_project = null;

page_init();
start_page_init();
i18n_init();
i18n_trans();

function page_init() {
    $('#menu_project').click();
}

function i18n_init() {
    if (typeof($lang) == "undefined") return;
    if (!fso.FileExists('assets/i18n/' + $lang + '.json')) return;
    var file = fso.OpenTextFile('assets/i18n/' + $lang + '.json', ForReading, false, true);
    var text = file.readall();
    file.close();
    $i18n = JSON.parse(text);
}

function i18n_trans() {
    $('.i18n-text').each(function(){
        $(this).text($i18n[$(this).text()]);
    });

    $('.i18n-title').each(function(){
        $(this).attr('title', $i18n[$(this).attr('title')]);
    });

}